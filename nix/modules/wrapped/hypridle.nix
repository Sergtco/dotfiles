{
  self,
  inputs,
  ...
}: let
  settings = ''
    general {
      after_sleep_cmd=niri msg action power-on-monitors
      before_sleep_cmd=hyprlock;
      lock_cmd=pidof hyprlock || hyprlock
    }

    listener {
      on-timeout=hyprlock
      timeout=300
    }

    listener {
      on-resume=niri msg action power-on-monitors
      on-timeout=niri msg action power-off-monitors
      timeout=330
    }

    listener {
      on-timeout=systemctl suspend
      timeout=1800
    }
  '';
in {
  perSystem = {pkgs, ...}: {
    packages.hypridle = inputs.wrapper-modules.lib.wrapPackage ({...}: {
      inherit pkgs;
      package = pkgs.hypridle;
      flags = {
        "-c" = pkgs.writeText "hyprilde.conf" settings;
      };
    });
  };
}
