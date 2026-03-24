{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: let
    settings = ''
      general {
          lock_cmd = pidof hyprlock || hyprlock
          before_sleep_cmd = loginctl lock-session
          after_sleep_cmd = niri msg action power-on-monitors"
      }

      listener {
          timeout = 300
          on-timeout = loginctl lock-session
      }

      listener {
          timeout = 330
          on-timeout = niri msg action power-off-monitors
          on-resume = niri msg action power-on-monitors
      }

      listener {
          timeout = 1800
          on-timeout = systemctl suspend
      }
    '';
  in {
    packages.hypridle = inputs.wrapper-modules.lib.wrapPackage ({...}: {
      inherit pkgs;
      package = pkgs.hypridle;
      flags = {
        "--config" = pkgs.writeText "hypridle.conf" settings;
      };
    });
  };
}
