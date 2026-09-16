{
  inputs,
  self,
  ...
}:
{
  # Jovian only validates against nixos-unstable, so this is the one host that
  # builds from `nixpkgs-unstable` instead of the pinned release. Everything
  # pulled in from `self.packages` is still built against the stable nixpkgs,
  # the same way `pkgs.unstable.*` is used the other way around elsewhere.
  flake.nixosConfigurations.steamdeck = inputs.nixpkgs-unstable.lib.nixosSystem {
    modules = [
      self.nixosModules.steamdeck
      inputs.hjem.nixosModules.default
    ];
  };

  flake.nixosModules.steamdeck =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      user = config.preferences.user.name;
      # The machines that build and push to this one.
      adminKeys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqz3UYJM7p/GvmFFXChZ42qmX2N3ZJ6nCHuxttCz9ZaXOR8NNQEYrEny7Kfmdr7n7cR1EHs3oMY1KN4cptKsNGH0ZIvTtRDcfRP2+4tHDj1A4Z3chxUF9CJzveOVITpphSCSh9LjXaqBpT/xRqB+ka4hD/v85cKfeRlvF2/SGlQQhaXXoRPZy3AxRXhEZujrzHGBrcPEH70G39j7yLxUbyJ5heOVnoq7NwpjUU+HNAn5ww1YmSu3OcAEM9lXvuDSjxEtVrbcoTOlIqudQFhGKc6IZoQFZV0bqD6mLeDZ+I/u2aQmnXU3FhFwC52NSqBgDz2ucNpQbnOe8j5RLse1/URx7C4obdZcAG9c9aCJeGScg7x0WBsqvqnoo/Xsc17ApkI3HE6ceVlKzG+s2MKWLsV1jzL3hacZRgMtGfzW4BFFopujQOgHnMzhuiyULGEx6uHp4Sm9WKprPGGDeBrnt7rtCMp2j+UQJx5zh8IyEtvgDu0R06WvHHBoZOhx5d5L0= home"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbsx8ktNrZIqWALY8dX36CWhCC9jrDhFlqMxVhK6ko6 lep-tep"
      ];
    in
    {
      imports = [
        inputs.jovian.nixosModules.default

        self.nixosModules.linux-base
        self.nixosModules.graphics-amd

        self.nixosModules.desktop
        self.nixosModules.theme
        self.nixosModules.zapret
      ];

      networking.hostName = "steamdeck";

      ### GAMING MODE ###
      # Jovian is the whole SteamOS userland: Valve's kernel, the Deck UI
      # (gamescope-session), steamos-manager, the fan curve, mura correction,
      # the vendor Mesa branches.
      #
      # `gaming` is deliberately not imported. It builds a gamescope session
      # for a 2560x1440 HDR monitor and ships a `steamos-session-select` stub,
      # both of which the real Deck session replaces — importing it would only
      # add a second, unused session and a binary collision.
      jovian = {
        devices.steamdeck = {
          enable = true;
          # Run the BIOS and controller firmware updaters at boot, as SteamOS
          # does. Off by default upstream; on here because the alternative is
          # firmware drifting until someone remembers to update it by hand.
          autoUpdate = true;
          # Gyro exposed as a Cemuhook DSU server, which is what emulators read.
          enableGyroDsuService = true;
        };

        steam = {
          enable = true;
          # Boot straight into Gaming Mode. This is what makes "Switch to
          # Desktop" work at all, and it brings its own display manager along
          # (SDDM with autologin), see the greetd override below.
          autoStart = true;
          inherit user;
          # "Switch to Desktop" lands in niri; quitting niri (Mod+Shift+E)
          # comes back here.
          desktopSession = "niri";

          # Written into /etc/xdg/gamescope-session/environment, which the
          # session sources before starting Steam.
          #
          # Gaming Mode gets no XDG_DATA_DIRS otherwise: NixOS sets it in
          # /etc/profile, and gamescope-session is a plain systemd user unit
          # that never sources one — the niri session only has it because
          # niri-session re-execs through a login shell. Without it Steam scans
          # nothing but the FHS sandbox's own /usr/share/applications, so "Add
          # a Non-Steam Game" comes up empty and shortcuts have no icons.
          environment.XDG_DATA_DIRS = lib.concatStringsSep ":" [
            "/home/${user}/.nix-profile/share"
            "/etc/profiles/per-user/${user}/share"
            "/run/current-system/sw/share"
            "/usr/local/share"
            "/usr/share"
          ];
        };

        # zram, earlyoom, the SteamOS sysctls and bluetooth defaults, SD card
        # automount. Implied by `steam.enable`, spelled out because it is what
        # makes this a SteamOS-alike rather than NixOS with Steam on it.
        steamos.useSteamOSConfig = true;

        decky-loader.enable = true;
      };

      # Jovian forwards these into the gamescope session, which is the only way
      # to get a layout other than us into Gaming Mode and its on-screen
      # keyboard.
      environment.variables = {
        XKB_DEFAULT_LAYOUT = "us,ru";
        XKB_DEFAULT_OPTIONS = "grp:win_space_toggle";
      };

      # Jovian enables desktop Steam itself, this is only the extra bits the
      # other hosts get from `gaming`.
      programs.steam = {
        extraCompatPackages = [ pkgs.proton-ge-bin ];
        protontricks.enable = true;
        # Steam Input — the on-screen keyboard included — fakes key events
        # through XTEST, which under Wayland only ever reaches XWayland
        # clients. extest is LD_PRELOADed into Steam and replays them through
        # uinput instead, so they arrive as ordinary kernel input events and
        # niri hands them to whatever is focused. Gaming Mode does not need it
        # (gamescope injects its own), but the preload is harmless there.
        extest.enable = true;
      };

      # What extest writes to. Jovian's udev rules already hand the session
      # user /dev/uinput via uaccess; this makes sure the module is loaded to
      # be opened in the first place.
      hardware.uinput.enable = true;

      environment.systemPackages = [
        # The updaters `autoUpdate` runs at boot, in PATH as well, so
        # `sudo jupiter-biosupdate` and `sudo jupiter-controller-update` can be
        # run by hand between reboots.
        pkgs.steamdeck-firmware
        # `pkgs` is nixpkgs-unstable on this host, so this is already the
        # unstable build; going through the `unstable` overlay instead would
        # fetch a second webkitgtk rather than share the system's.
        #
        # --no-window-decorations hides the libadwaita header bar, which is
        # wasted height on a 1280x800 handheld. It is an app flag rather than a
        # compositor setting because GTK4 never implements the wayland
        # decoration protocol, so niri's `prefer-no-csd` cannot reach it.
        #
        # Wrapped to drop LC_ALL: libmpv refuses to initialise unless
        # LC_NUMERIC is C, nixpkgs wraps the binary to set exactly that, and
        # `locale.nix` exports LC_ALL — which POSIX says overrides every other
        # LC_*, so the packaged wrapper never takes effect and mpv_create()
        # returns null. Unsetting it here lets that wrapper do its job.
        #
        # FFMPEG_BIN/FFPROBE_BIN because the bundled server.js shells out to
        # `ffprobe` to inspect a stream, and the package only puts nodejs on
        # PATH — fine from a shell that happens to have ffmpeg, but launched
        # from Steam it exits 127 and no stream ever loads.
        #
        # LD_LIBRARY_PATH because Steam launches everything inside its scout
        # runtime's library path, which ships libva 2.10; mpv then loads that
        # instead of the system's 2.24 and cannot open a Mesa 26 VA driver, so
        # hardware decoding dies with "Could not create a VA display". The
        # packaged wrapper re-adds /run/opengl-driver/lib right after, which is
        # all a Nix-built binary needs.
        (pkgs.symlinkJoin {
          name = "stremio-linux-shell-no-lc-all";
          paths = [ pkgs.stremio-linux-shell ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/stremio \
              --add-flags --no-window-decorations \
              --unset LC_ALL \
              --unset LD_LIBRARY_PATH \
              --set-default FFMPEG_BIN ${lib.getBin pkgs.ffmpeg-headless}/bin/ffmpeg \
              --set-default FFPROBE_BIN ${lib.getBin pkgs.ffmpeg-headless}/bin/ffprobe
          '';
        })
      ];

      # Stremio ships `DBusActivatable=true` plus a D-Bus service file that
      # hardcodes the *unwrapped* binary, so anything launching it through
      # activation skips the wrapper above and gets the mpv locale crash back.
      # Both are overridden per-user, pointed at the generation symlink so they
      # survive a rebuild, with activation off so the Exec line always wins.
      hjem.users.${user}.xdg.data.files = {
        "applications/com.stremio.Stremio.desktop".text = ''
          [Desktop Entry]
          Name=Stremio
          Comment=Freedom To Stream
          Icon=com.stremio.Stremio
          Categories=Utility;AudioVideo;Video;Player;
          Keywords=Stremio;Media;Play;
          Type=Application
          Exec=/run/current-system/sw/bin/stremio %u
          MimeType=x-scheme-handler/stremio;
          Terminal=false
          StartupNotify=true
          DBusActivatable=false
        '';

        "dbus-1/services/com.stremio.Stremio.service".text = ''
          [D-BUS Service]
          Name=com.stremio.Stremio
          Exec=/run/current-system/sw/bin/stremio --gapplication-service
        '';
      };

      ### REMOTE ACCESS ###
      # The one host here without a keyboard of its own: Gaming Mode has no
      # terminal and Desktop Mode wants one plugged in, so ssh is how this
      # machine gets administered. Root by key as well, because that is what
      # nixos-anywhere and `nixos-rebuild --target-host` reach for, and there
      # is no root password to fall back on.
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "prohibit-password";
        };
      };

      users.users.${user}.openssh.authorizedKeys.keys = adminKeys;
      users.users.root.openssh.authorizedKeys.keys = adminKeys;

      ### LOGIN ###
      # `desktop` sets up greetd, but Gaming Mode's autostart wants SDDM with
      # autologin and the two cannot both own display-manager.service.
      services.greetd.enable = lib.mkForce false;
      security.pam.services.sddm.enableGnomeKeyring = true;

      ### DISPLAY ###
      # Internal panel, so the kernel backlight class is the thing to write to.
      # Jovian already loosens the permissions on those device nodes.
      preferences.brightness.backend = "brightnessctl";

      # Nothing rotates the panel here on purpose. It scans out 800x1280, but
      # the kernel quirk table reports its orientation for both Jupiter and
      # Galileo, and niri reads that DRM property and *composes* it with the
      # configured transform — so asking for 270 on top of the detected 270
      # would land upside-down. The shared niri config's `eDP-1` mode is the
      # laptop's 1920x1080, which does not exist here; niri falls back to the
      # preferred mode.

      # SteamOS runs the desktop Steam client in Desktop Mode as well — that is
      # what puts it in the tray and gives the Steam button chords something to
      # talk to there. Bound to niri rather than dropped in /etc/xdg/autostart
      # so it cannot start inside Gaming Mode, which has a Steam of its own.
      systemd.user.services.steam-desktop = {
        description = "Steam client in the niri session, as SteamOS runs it in Desktop Mode";
        after = [ "niri.service" ];
        partOf = [ "niri.service" ];
        wantedBy = [ "niri.service" ];
        serviceConfig = {
          Type = "simple";
          # -silent starts it into the tray instead of opening the window.
          ExecStart = "${lib.getExe config.programs.steam.package} -silent";
          # Quitting Steam from the tray should stay quit.
          Restart = "no";
        };
      };

      ### BOOT ###
      # Every generation on the ESP is a Valve kernel plus its initrd, so the
      # 10 that `linux-base` keeps do not fit in a Deck-sized boot partition.
      boot.loader.systemd-boot.configurationLimit = lib.mkForce 5;
      # There is no keyboard to hold Space on, so the menu is only really
      # reachable docked — still worth the three seconds for a rollback.
      # (The firmware boot menu is Volume Down + Power.)
      boot.loader.timeout = lib.mkForce 3;
    };
}
