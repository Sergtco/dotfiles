{
  description = "Sergtco's flake";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    determinate,
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
        extraModules = [
          stylix.nixosModules.stylix
          determinate.nixosModules.default
        ];
      };
      lep-tep = myLib.buildCfg {
        system = "x86_64-linux";
        hostname = "lep-tep";
        extraModules = [
          stylix.nixosModules.stylix
          determinate.nixosModules.default
        ];
      };
    };
  };
}
