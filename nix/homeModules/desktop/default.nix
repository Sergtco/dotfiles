{pkgs, ...}: {
  imports = [
    ./mimeapps.nix
    ./browser
    ./waybar
    ./rofi
  ];
  services = {
    udiskie.enable = true;
    swaync = {
      enable = true;
      settings = ../../../config/swaync/config.json;
    };

    swayosd.enable = true;
    hyprpolkitagent.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      ${builtins.readFile ../../../config/hypr/hyprland.conf}
    '';
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        before_sleep_cmd = "hyprlock;";
      };

      listeners = [
        {
          timeout = 300;
          on-timeout = "hyprlock";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    pavucontrol
    mpv
    gedit
    eog
    brightnessctl
    vesktop
    thunderbird
  ];
}
