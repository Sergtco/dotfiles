{ self, inputs, ... }:
let
  opts =
    { lib, ... }:
    {
      options.preferences = {
        user.name = lib.mkOption {
          type = lib.types.str;
          default = "sergtco";
        };
      };
    };
in
{
  flake.nixosModules.base = opts;
  flake.darwinModules.base = opts;
}
