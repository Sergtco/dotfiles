{ self, ... }:
{
  # Every `preferences.*` option lives here so that hosts can set them without
  # having to import the feature module that happens to consume them.
  flake.nixosModules.preferences =
    { lib, ... }:
    {
      options.preferences = {
        user.name = lib.mkOption {
          type = lib.types.str;
          default = "sergtco";
          description = "Login name of the primary user of the host.";
        };

        user.flake = lib.mkOption {
          type = lib.types.str;
          default = "/home/sergtco/dotfiles";
          description = "Path to system's flake";
        };

        login.autologin = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Skip the greeter and log the primary user straight into wm.";
        };

        brightness = {
          backend = lib.mkOption {
            type = lib.types.enum [
              "brightnessctl"
              "ddcci"
            ];
            default = "brightnessctl";
            description = ''
              How the brightness keys drive the display.

              `brightnessctl` writes to the kernel backlight class, which only
              exists for internal panels. `ddcci` talks DDC/CI to an external
              monitor over i2c with ddcutil, and needs `brightness.i2cBus`.
            '';
          };

          i2cBus = lib.mkOption {
            type = lib.types.nullOr lib.types.int;
            default = null;
            example = 6;
            description = ''
              i2c bus the monitor answers DDC/CI on, for the `ddcci` backend.
              Find it with `ddcutil detect`; a bare `i2cget` probe is not a
              reliable test on DisplayPort, where DDC is tunneled over AUX.
            '';
          };
        };
      };
    };

  # `base` is what hosts import; it currently only carries the options, but is
  # the place to put config that every host should get unconditionally.
  flake.nixosModules.base = {
    imports = [ self.nixosModules.preferences ];
  };
}
