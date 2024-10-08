{inputs}: let
  myLib = (import ./default.nix) {inherit inputs;};
in {
  homeInit = file: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = {inherit inputs;};
    home-manager.users.sergtco = import file;
  };
  buildCfg = {
    system,
    hostname,
  }:
    inputs.nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = {inherit inputs;};
      modules = [
        ../hosts/${hostname}/configuration.nix
        inputs.home-manager.nixosModules.home-manager
        (myLib.homeInit ../hosts/${hostname}/home.nix)
      ];
    };
}
