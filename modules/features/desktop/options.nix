{self, inputs, ...}: {
  flake.nixosModules.desktop = {lib, ...}: {
    options.preferences = {
      login.autologin = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
}
