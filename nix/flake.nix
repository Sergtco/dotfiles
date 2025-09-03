{
  description = "Sergtco's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix/release-25.05";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    stylix,
    nix-index-database,
    ...
  } @ inputs: let
    myLib = import ./myLib {inherit inputs;};
  in {
    nixosConfigurations = {
      sergt-pc = myLib.buildCfg {
        system = "x86_64-linux";
        hostname = "sergt-pc";
        extraModules = [stylix.nixosModules.stylix];
      };
      lep-tep = myLib.buildCfg {
        system = "x86_64-linux";
        hostname = "lep-tep";
        extraModules = [stylix.nixosModules.stylix];
      };
    };
  };
}
