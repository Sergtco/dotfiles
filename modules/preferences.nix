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

        login.autologin = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Skip the greeter and log the primary user straight into wm.";
        };
      };
    };

  # `base` is what hosts import; it currently only carries the options, but is
  # the place to put config that every host should get unconditionally.
  flake.nixosModules.base = {
    imports = [ self.nixosModules.preferences ];
  };
}
