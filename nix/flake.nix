{
  description = "Sergtco's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix/release-24.11";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    myLib = import ./myLib {inherit inputs;};
  in {
    nixosConfigurations = {
      sergt-pc = myLib.buildCfg {
        system = "x86_64-linux";
        hostname = "sergt-pc";
      };
      lep-tep = myLib.buildCfg {
        system = "x86_64-linux";
        hostname = "lep-tep";
      };
    };
  };
}
