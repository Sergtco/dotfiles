{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./mimeapps.nix
    ./browser
    ./waybar
    ./fuzzel
    ./music.nix
  ];
  xdg.userDirs.enable = true;
  services = {
    udiskie.enable = true;
    fnott = {
      enable = true;
      settings = {
        main = {
          default-timeout = 5;
          max-timeout = 10;
          selection-helper = "fuzzel --dmenu";
          layer = "overlay";
        };
      };
    };

    swayosd.enable = true;
    hyprpaper.enable = true;
    hyprpolkitagent.enable = true;
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.configFile = {
    "niri/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/niri/config.kdl";
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        after_sleep_cmd = "niri msg action power-on-monitors";
        before_sleep_cmd = "hyprlock;";
      };

      listeners = [
        {
          timeout = 300;
          on-timeout = "hyprlock";
        }
        {
          timeout = 330;
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "niri msg action power-on-monitors";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  systemd.user.services.wlsunset = {
    Unit = {
      Description = "Night light";
    };
    Service = {
      Restart = "always";
      ExecStart = "${pkgs.wlsunset}/bin/wlsunset -S 7:00 -s 22:00";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  programs.vesktop.enable = true;
  home.packages = with pkgs; [
    pavucontrol
    mpv
    gedit
    swayimg
    brightnessctl
    thunderbird

    libnotify
    (pkgs.writeShellScriptBin "toggle-notification" (builtins.readFile ./scripts/toggle-notification.sh))
  ];
}
