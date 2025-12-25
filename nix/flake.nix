{
  description = "Sergtco's flake";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*";
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "https://flakehub.com/f/nix-darwin/nix-darwin/0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    determinate,
    nixpkgs,
    nur,
    home-manager,
    nix-index-database,
    nix-darwin,
    stylix,
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
          nix-index-database.nixosModules.nix-index
          determinate.nixosModules.default
        ];
      };
      lep-tep = myLib.buildCfg {
        system = "x86_64-linux";
        hostname = "lep-tep";
        extraModules = [
          stylix.nixosModules.stylix
          nix-index-database.nixosModules.nix-index
          determinate.nixosModules.default
        ];
      };
    };
    darwinConfigurations."MacBook-Pro-user" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/work/configuration.nix
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.user = import ./hosts/work/home.nix;
        }
      ];
    };
  };
}
