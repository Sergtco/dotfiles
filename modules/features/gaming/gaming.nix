_: {
  flake.nixosModules.gaming =
    { pkgs, ... }:
    {
      boot.initrd.kernelModules = [
        "xpad"
      ];
      boot.kernelModules = [ "ntsync" ];

      programs.steam = {
        enable = true;
        package = pkgs.steam.override {
          extraProfile = ''
            export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
            export PROTON_ENABLE_WAYLAND=1
          '';
        };
        extraCompatPackages = [ pkgs.unstable.proton-ge-bin ];
        extraPackages = [
          pkgs.mangohud
        ];
        protontricks.enable = true;
        gamescopeSession = {
          enable = true;
          env = {
            "XKB_DEFAULT_LAYOUT" = "us,ru";
            "XKB_DEFAULT_OPTIONS" = "grp:win_space_toggle";
          };
          args = [
            "-W 2560"
            "-H 1440"
            "--hdr-enabled"
            "--hdr-itm-enable"
            "-f"
            "-e"
            "--rt"
            "--steam"
            "-- ${pkgs.util-linux}/bin/setpriv --ambient-caps=-all --inh-caps=-all"
          ];
          steamArgs = [
            "-gamepadui"
            "-steamdeck"
          ];
        };
      };

      programs.gamescope = {
        enable = true;
        capSysNice = true;
        args = [
          "--force-grab-cursor"
          "-f"
          "--force-composition"
        ];
      };

      programs.gamemode.enable = true;

      services.joycond.enable = true;
      services.udev.packages = [ pkgs.game-devices-udev-rules ];
      hardware.uinput.enable = true;
      environment.systemPackages = with pkgs; [
        r2modman
        (pkgs.lutris.override {
          extraPkgs =
            pkgs: with pkgs; [
              proton-ge-bin
              wine
              winetricks
              mangohud
              umu-launcher
              gamescope
              gamemode
            ];
        })
        gamescope-wsi
        (pkgs.writeShellScriptBin "steamos-session-select" ''
          set -eu
          printf '%s\n' "''${1:-gamescope}" > "$HOME/.local/state/steamos-session"
          steam -shutdown || true
        '')
      ];

      services.ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos;
      };

      services.pipewire.extraConfig.pipewire."92-low-latency" = {
        "context.properties"."default.clock.quantum" = 512;
        "context.properties"."default.clock.min-quantum" = 256;
      };
      services.lact.enable = true;
      hardware.amdgpu.overdrive.enable = true;
      services.scx = {
        enable = true;
        scheduler = "scx_lavd";
      };
    };
}
