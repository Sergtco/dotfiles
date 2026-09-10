{ self, ... }:
{
  # Triton: D3D10/11/12 + Vulkan in a Windows guest on virtio-gpu, no GPU
  # passthrough. Guest D3D calls travel over the virtio-gpu "neptune" capset to
  # a render server on the host, which executes them through DXVK-Native on
  # RADV. Three forks are involved, none of them packaged anywhere:
  #
  #   osy/dxvk            - DXVK-Native with a headless WSI and the dma-buf
  #                         shared-resource contract the render server needs.
  #   utmapp/virglrenderer- the neptune host module (dlopens the dxvk libs).
  #   utmapp/qemu         - QEMU 10.0.12 + the neptune capset plumbing.
  #
  # The guest side (viogpu3d.sys KMD + neptune_umd.dll UMD + Venus vulkan ICD)
  # ships prebuilt and Microsoft attestation-signed in osy's releases, so the
  # guest needs no test-signing mode and Secure Boot may stay on; it is
  # packaged below as a driver ISO the launcher attaches automatically.
  #
  # Alpha-quality stack: snapshot the VM before driver updates.
  perSystem =
    { pkgs, lib, ... }:
    let
      # DXVK built as native Linux libraries. This is what actually renders:
      # the render server dlopens libdxvk_{d3d11,dxgi}.so and feeds it the
      # guest's D3D11 stream. Headless WSI only - there is no window on this
      # side, QEMU scans out the shared textures itself.
      triton-dxvk = pkgs.stdenv.mkDerivation {
        pname = "triton-dxvk";
        version = "2.7.1-osy-404240f";
        src = pkgs.fetchFromGitHub {
          owner = "osy";
          repo = "dxvk";
          rev = "404240fdacf47470b02c76d6e684639a95dc7387";
          # Submodules are mandatory: mingw directx headers (installed for
          # virglrenderer to compile against), dxbc-spirv and the <0.2.0
          # libdisplay-info fork (nixpkgs' 0.3.0 is out of range).
          fetchSubmodules = true;
          hash = "sha256-2DeNC6uIMxiL/AtDg1g6HHKJn/Lw2GUABIwPbuUnhK0=";
        };
        nativeBuildInputs = with pkgs; [
          meson # dxbc-spirv subproject wants meson >= 1.0
          ninja
          pkg-config
          glslang
          python3 # libdisplay-info's gen-search-table.py
        ];
        buildInputs = [ pkgs.vulkan-loader ];
        postPatch = ''
          patchShebangs subprojects/libdisplay-info/tool
        '';
        mesonFlags = [
          "-Denable_dxgi=true"
          "-Denable_d3d11=true"
          # d3d11 statically carries the d3d10 translation layer either way;
          # these only control separate libraries nothing here dlopens.
          "-Denable_d3d10=false"
          "-Denable_d3d9=false"
          "-Denable_d3d8=false"
          "-Dnative_headless=true"
          "-Dnative_sdl3=disabled"
          "-Dnative_sdl2=disabled"
          "-Dnative_glfw=disabled"
        ];
        # libvulkan is dlopened, not linked, so the fixup rpath shrink would
        # strip vulkan-loader; put it back after the shrink runs.
        postFixup = ''
          for f in "$out"/lib/libdxvk_*.so*; do
            [ -L "$f" ] || patchelf --add-rpath ${lib.makeLibraryPath [ pkgs.vulkan-loader ]} "$f"
          done
        '';
      };

      triton-virglrenderer = pkgs.virglrenderer.overrideAttrs (old: {
        pname = "triton-virglrenderer";
        version = "1.3.0-utm-482f9d8";
        src = pkgs.fetchFromGitHub {
          owner = "utmapp";
          repo = "virglrenderer";
          rev = "482f9d8b8c2d2288efa10a027116216909d2c226"; # macos-next
          hash = "sha256-VCAmJmfIpy4h3LGhFX1ileiE7+Le9IQz/6Y1iLuqNyk=";
        };
        # nixpkgs' only patch targets the amdgpu drm renderer disabled below.
        patches = [ ];
        # Replaced wholesale: nixpkgs passes drm-renderers=amdgpu-experimental,...
        # which the fork would turn into a hard libdrm_amdgpu>=2.4.121 dep.
        mesonFlags = [
          "-Dvenus=true"
          "-Dneptune=true"
          "-Dplatforms=egl"
          "-Ddrm-renderers="
          "-Dvideo=false"
          # Puts -DVIRGL_RENDERER_UNSTABLE_APIS in the .pc cflags so QEMU sees
          # the scanout-handle/fence-export declarations it probes for.
          "-Dunstable-apis=true"
        ];
        # neptune needs dxvk-dxgi.pc + dxvk_shared_resource.h at build time
        # (headers only - the libs themselves are dlopened at runtime).
        buildInputs = old.buildInputs ++ [ triton-dxvk ];
        # Venus dlopens libvulkan.so.1; same shrink-proofing as triton-dxvk.
        postFixup = (old.postFixup or "") + ''
          for f in "$out"/lib/libvirglrenderer.so* "$out"/libexec/virgl_render_server; do
            [ -L "$f" ] || patchelf --add-rpath ${lib.makeLibraryPath [ pkgs.vulkan-loader ]} "$f"
          done
        '';
      });

      # The three meson subprojects a git checkout of QEMU downloads at
      # configure time (release tarballs vendor them); pinned to the revisions
      # in the fork's subprojects/*.wrap files.
      qemuSubproject = repo: rev: hash:
        pkgs.fetchFromGitLab {
          owner = "qemu-project";
          inherit repo rev hash;
        };
      keycodemapdb =
        qemuSubproject "keycodemapdb" "f5772a62ec52591ff6870b7e8ef32482371f22c6"
          "sha256-GbZ5mrUYLXMi0IX4IZzles0Oyc095ij2xAsiLNJwfKQ=";
      softfloat =
        qemuSubproject "berkeley-softfloat-3" "b64af41c3276f97f0e181920400ee056b9c88037"
          "sha256-Yflpx+mjU8mD5biClNpdmon24EHg4aWBZszbOur5VEA=";
      testfloat =
        qemuSubproject "berkeley-testfloat-3" "e7af9751d9f9fd3b47911f51a5cfd08af256a9ab"
          "sha256-inQAeYlmuiRtZm37xK9ypBltCJ+ycyvIeIYZK8a+RYU=";

      triton-qemu =
        (pkgs.qemu.override {
          hostCpuOnly = true;
          virglrenderer = triton-virglrenderer;
        }).overrideAttrs
          (old: {
            pname = "triton-qemu";
            version = "10.0.12-utm-227f8b6";
            src = pkgs.fetchFromGitHub {
              owner = "utmapp";
              repo = "qemu";
              rev = "227f8b678b0f7783cdaff1a57f8338398b2100ff"; # utm-edition
              hash = "sha256-WxWcoBsg9+P/M6dYNdAM5T+DHVLEflrRFaeCEd8dZRA=";
            };
            # Keep only the qga path fix; the macos icon patch and the 10.2
            # nested-virt revert don't apply to the 10.0-based fork.
            patches = builtins.filter (p: lib.hasSuffix "fix-qemu-ga.patch" (toString p)) old.patches;
            # The fork's spice GL path includes <GLES2/gl2.h> directly.
            buildInputs = old.buildInputs ++ [ pkgs.libglvnd ];
            postPatch =
              (old.postPatch or "")
              + ''
                # Fork bugs in the linux (CONFIG_GBM) spice+GL path, which UTM's
                # darwin CI never compiles: a stray argument left over from the
                # 8-arg upstream egl_texture_blend, and width/height locals lost
                # while hoisting declarations in qemu_spice_gl_update.
                substituteInPlace ui/spice-display.c \
                  --replace-fail "!y_0_top, false, ptr_x, ptr_y, 1.0, 1.0);" \
                                 "!y_0_top, ptr_x, ptr_y, 1.0, 1.0);" \
                  --replace-fail "QemuDmaBuf *dmabuf = ssd->guest_dmabuf;" \
                                 "QemuDmaBuf *dmabuf = ssd->guest_dmabuf;
        uint32_t width, height;"

                # ... and two more that only bite at runtime. Without a `gl=`
                # among the -spice options gl_str is NULL, which qapi_bool_parse
                # then dereferences: plain SPICE (what libvirt emits) segfaults
                # before the guest starts.
                substituteInPlace ui/spice-display.c \
                  --replace-fail 'gl_str = qemu_opt_get(opts, "gl");' \
                                 'gl_str = qemu_opt_get(opts, "gl"); if (!gl_str) gl_str = "off";'

                # The darwin branches of this if/else set spice_opengl, the GBM
                # one forgets to, so on linux the GL display listener and
                # context ops are never installed and every GL device fails
                # to realize with "The console requires a GL context".
                substituteInPlace ui/spice-display.c \
                  --replace-fail 'egl_init(qemu_opt_get(opts, "rendernode"), DISPLAY_GL_MODE_ON, &error_fatal);' \
                                 'egl_init(qemu_opt_get(opts, "rendernode"), DISPLAY_GL_MODE_ON, &error_fatal); spice_opengl = DISPLAY_GL_MODE_ON;'

                cp -r --no-preserve=mode ${keycodemapdb} subprojects/keycodemapdb
                cp -r --no-preserve=mode ${softfloat} subprojects/berkeley-softfloat-3
                cp -r --no-preserve=mode subprojects/packagefiles/berkeley-softfloat-3/. subprojects/berkeley-softfloat-3/
                cp -r --no-preserve=mode ${testfloat} subprojects/berkeley-testfloat-3
                cp -r --no-preserve=mode subprojects/packagefiles/berkeley-testfloat-3/. subprojects/berkeley-testfloat-3/
              '';
          });

      # Attestation-signed guest driver package as a Joliet ISO. Joliet is
      # load-bearing: plain ISO-9660 8.3-mangles neptune_umd_x86.dll and the
      # catalog hash check then fails. Install in the guest with
      #   pnputil /add-driver D:\viogpu3d\viogpu3d.inf /install
      triton-guest-drivers = pkgs.runCommand "triton-guest-drivers-0.3" {
        src = pkgs.fetchurl {
          url = "https://github.com/osy/kvm-guest-drivers-windows/releases/download/v0.3/viogpu3d-x64-signed.zip";
          hash = "sha256-JFJmcY+5SoXV3h4H/5te8pGJf78GB7il3/hsd1TUrvk=";
        };
        nativeBuildInputs = with pkgs; [
          unzip
          xorriso
        ];
      } ''
        unzip -q $src -d stage
        mkdir -p isoroot $out
        cp -r stage/drivers/viogpu3d isoroot/
        xorrisofs -r -J -joliet-long -V VIOGPU3D -o $out/viogpu3d.iso isoroot
      '';

      # NPT_* point the render server at the dxvk libs (the compiled-in
      # defaults are bare sonames that would go through the empty dlopen
      # search path). DXVK_WSI_DRIVER=Headless and the render server exec
      # path are baked in, nothing else to set.
      triton-vm = pkgs.writeShellApplication {
        name = "triton-vm";
        text = ''
          mem="''${TRITON_MEM:-8G}"
          smp="''${TRITON_SMP:-8}"
          hostmem="''${TRITON_HOSTMEM:-8G}"

          # The guest's scanout must stay under 4,194,304 pixels or it
          # bugchecks the VM, so the advertised EDID is pinned here.
          #
          # viogpu3d sizes its frame segment from BAR 0, but only when the
          # registry value UsePhysicalMemory is set -- and the shipped INF sets
          # it to 0, so viogpu_adapter.cpp HWInit always takes the fallback and
          # the segment is the hard-coded 16MiB `req_size`. A mode whose
          # framebuffer exceeds that reaches the "segment too small" branch of
          # VioGpuObj::Init, which logs through a still-NULL m_pSegment
          # (upstream PR osy/kvm-guest-drivers-windows#3) and takes the guest
          # down instead of failing the mode. 16MiB / 4 bytes caps it at
          # 2560x1600; 4K needs 31.6MiB and cannot work until that is fixed.
          xres="''${TRITON_XRES:-1920}"
          yres="''${TRITON_YRES:-1080}"

          export NPT_D3D11_LIBRARY_PATH="${triton-dxvk}/lib/libdxvk_d3d11.so"
          export NPT_DXGI_LIBRARY_PATH="${triton-dxvk}/lib/libdxvk_dxgi.so"

          # TRITON_NO3D=1 boots on plain emulated VGA, so the viogpu3d KMD never
          # loads. That is the way back in when the 3D driver bugchecks the
          # guest during boot: Windows comes up on the basic display adapter and
          # the driver can be removed with `pnputil /delete-driver ... /force`.
          if [ -n "''${TRITON_NO3D:-}" ]; then
            gpu=(-vga std -display gtk)
          else
            # The 3D path is OFF by default because it does not currently boot:
            # `blob=on` alone -- venus and neptune both off, at every hostmem
            # size from 128M to 8G -- bugchecks the guest in dxgmms2.sys before
            # it issues a single virtio-gpu resource command. Enabling blob is
            # what makes the device expose a shmem region, which is the sole
            # trigger for the KMD reporting its second, CPU-visible segment to
            # the Windows video memory manager (QUERYSEGMENT3/4 in
            # viogpu_adapter.cpp, whose Aperture flag carries the author's own
            # "FIXME: is this correct?"). Since neptune requires blob, there is
            # no working D3D configuration with viogpu3d v0.3.
            #
            # TRITON_3D=1 opts back in -- use it to retest once the driver is
            # fixed. TRITON_GPUOPTS overrides the suboptions outright.
            if [ -n "''${TRITON_3D:-}" ]; then
              default_opts="venus=on,neptune=on,blob=on,hostmem=$hostmem"
            else
              default_opts="venus=off,neptune=off"
            fi
            opts="''${TRITON_GPUOPTS:-$default_opts}"
            gpu=(
              -vga none
              -device "virtio-vga-gl,$opts,xres=$xres,yres=$yres"
              -display "gtk,gl=on"
            )
          fi

          # TRITON_TRACE=/path/to/log records the virtio-gpu command stream, so
          # a guest crash leaves behind what the driver asked for last.
          trace=()
          if [ -n "''${TRITON_TRACE:-}" ]; then
            trace=(-trace "virtio_gpu_*,file=$TRITON_TRACE")
          fi

          # TRITON_UEFI=1 boots via OVMF instead of SeaBIOS. Upstream develops
          # against UTM, which is UEFI-only, so the blob/hostmem path has
          # probably never run under a legacy BIOS -- and Windows on legacy BIOS
          # is historically poor at handling the multi-gigabyte 64-bit BAR this
          # device exposes. The guest install must already be UEFI/GPT (convert
          # an existing MBR install in-place with Windows' own `mbr2gpt`).
          fw=()
          if [ -n "''${TRITON_UEFI:-}" ]; then
            vars="''${TRITON_UEFI_VARS:-$HOME/.local/share/triton/OVMF_VARS.fd}"
            if [ ! -f "$vars" ]; then
              mkdir -p "$(dirname "$vars")"
              install -m600 ${pkgs.OVMF.fd}/FV/OVMF_VARS.fd "$vars"
            fi
            fw=(
              -drive "if=pflash,format=raw,readonly=on,file=${pkgs.OVMF.fd}/FV/OVMF_CODE.fd"
              -drive "if=pflash,format=raw,file=$vars"
            )
          fi

          exec ${triton-qemu}/bin/qemu-system-x86_64 \
            -accel kvm,honor-guest-pat=auto -cpu host -smp "$smp" -m "$mem" \
            -object memory-backend-memfd,id=mem1,size="$mem",share=on \
            -machine q35,memory-backend=mem1 \
            "''${fw[@]}" \
            "''${gpu[@]}" \
            "''${trace[@]}" \
            -device qemu-xhci -device usb-tablet \
            -audiodev pipewire,id=snd0 -device intel-hda -device hda-duplex,audiodev=snd0 \
            -drive file=${triton-guest-drivers}/viogpu3d.iso,media=cdrom \
            "$@"
        '';
      };

      # libvirt builds its own command line, so the two things it cannot express
      # are wrapped around the binary instead: the NPT_* paths, and
      # honor-guest-pat. The latter has to be a rewrite rather than an appended
      # argument because QEMU keeps the first -accel that initialises
      # (system/vl.c do_configure_accelerator) and libvirt's own plain
      # `-accel kvm` always comes first.
      triton-qemu-libvirt = pkgs.runCommand "triton-qemu-libvirt" { } ''
        mkdir -p $out/bin
        cat > $out/bin/qemu-system-x86_64 <<'EOF'
        #!${pkgs.runtimeShell}
        export NPT_D3D11_LIBRARY_PATH="${triton-dxvk}/lib/libdxvk_d3d11.so"
        export NPT_DXGI_LIBRARY_PATH="${triton-dxvk}/lib/libdxvk_dxgi.so"
        args=()
        prev=""
        for a in "$@"; do
          if [ "$prev" = "-accel" ]; then
            case "$a" in
              *honor-guest-pat=*) ;;
              kvm | kvm,*) a="$a,honor-guest-pat=auto" ;;
            esac
          fi
          args+=("$a")
          prev="$a"
        done
        exec ${triton-qemu}/bin/qemu-system-x86_64 "''${args[@]}"
        EOF
        chmod +x $out/bin/qemu-system-x86_64
      '';
    in
    {
      packages = {
        inherit
          triton-dxvk
          triton-virglrenderer
          triton-qemu
          triton-qemu-libvirt
          triton-guest-drivers
          triton-vm
          ;
      };
    };

  # Usage: qemu-img create -f qcow2 win.qcow2 100G, then
  #   triton-vm -drive file=win.qcow2,if=virtio -cdrom Win10.iso
  # (installer first boot; afterwards drop the -cdrom). The driver ISO is
  # always attached; sizes via TRITON_MEM / TRITON_SMP / TRITON_HOSTMEM.
  flake.nixosModules.triton =
    { config, pkgs, ... }:
    let
      selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
      user = config.preferences.user.name;
    in
    {
      users.users.${user}.extraGroups = [ "kvm" ];
      environment.systemPackages = [
        selfpkgs.triton-vm
        selfpkgs.triton-qemu # qemu-img and friends
      ];

      # A domain XML has to name an emulator by path, and a store path would go
      # stale on the next rebuild. This symlink is the stable name to point
      # <emulator> at; it follows the current system generation.
      environment.etc."triton/qemu-system-x86_64".source =
        "${selfpkgs.triton-qemu-libvirt}/bin/qemu-system-x86_64";

      # Ready to `virsh define`. libvirt cannot express neptune/venus/hostmem on
      # its own, hence the qemu:override block; <acceleration> must sit inside
      # <model> or libvirt silently emits plain virtio-vga, which has no such
      # properties and fails to start.
      environment.etc."triton/win-triton.xml".text = ''
        <domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
          <name>win-triton</name>
          <memory unit='GiB'>8</memory>
          <currentMemory unit='GiB'>8</currentMemory>
          <memoryBacking>
            <source type='memfd'/>
            <access mode='shared'/>
          </memoryBacking>
          <vcpu placement='static'>8</vcpu>
          <os><type arch='x86_64' machine='q35'>hvm</type></os>
          <features><acpi/><apic/></features>
          <cpu mode='host-passthrough' check='none' migratable='off'/>
          <devices>
            <emulator>/etc/triton/qemu-system-x86_64</emulator>
            <disk type='file' device='disk'>
              <driver name='qemu' type='qcow2'/>
              <source file='/home/${user}/win.qcow2'/>
              <target dev='vda' bus='virtio'/>
            </disk>
            <disk type='file' device='cdrom'>
              <driver name='qemu' type='raw'/>
              <source file='${selfpkgs.triton-guest-drivers}/viogpu3d.iso'/>
              <target dev='sdb' bus='sata'/>
              <readonly/>
            </disk>
            <video>
              <model type='virtio' heads='1' primary='yes'>
                <acceleration accel3d='yes'/>
              </model>
            </video>
            <!--
              egl-headless supplies the GL context the device needs; SPICE is
              only the console. `<gl enable='yes'/>` on the SPICE element looks
              like the better option (it hands over dmabufs instead of copying
              frames) but it is broken in this fork beyond the two fixes above,
              and libvirt refuses to pair it with egl-headless anyway
              ("multiple OpenGL displays are not supported by QEMU").
            -->
            <graphics type='spice'>
              <listen type='none'/>
              <gl enable='no'/>
            </graphics>
            <graphics type='egl-headless'/>
            <input type='tablet' bus='usb'/>
            <controller type='usb' model='qemu-xhci'/>
          </devices>
          <qemu:override>
            <qemu:device alias='video0'>
              <qemu:frontend>
                <qemu:property name='blob' type='bool' value='true'/>
                <qemu:property name='venus' type='bool' value='true'/>
                <qemu:property name='neptune' type='bool' value='true'/>
                <qemu:property name='hostmem' type='unsigned' value='8589934592'/>
                <!-- Keeps the scanout under viogpu3d's 16MiB frame segment;
                     see the comment in triton-vm. Do not exceed 2560x1600. -->
                <qemu:property name='xres' type='unsigned' value='1920'/>
                <qemu:property name='yres' type='unsigned' value='1080'/>
              </qemu:frontend>
            </qemu:device>
          </qemu:override>
        </domain>
      '';
    };
}
