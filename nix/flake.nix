{
  description = "Sergtco's flake";

  # outputs = {
  #   determinate,
  #   nixpkgs,
  #   nur,
  #   home-manager,
  #   nix-index-database,
  #   nix-darwin,
  #   stylix,
  #   ...
  # } @ inputs: let
  #   myLib = import ./myLib {inherit inputs;};
  # in {
  #   nixosConfigurations = {
  #     sergt-pc = myLib.buildCfg {
  #       system = "x86_64-linux";
  #       hostname = "sergt-pc";
  #       extraModules = [
  #         stylix.nixosModules.stylix
  #         nix-index-database.nixosModules.nix-index
  #         determinate.nixosModules.default
  #       ];
  #     };
  #     lep-tep = myLib.buildCfg {
  #       system = "x86_64-linux";
  #       hostname = "lep-tep";
  #       extraModules = [
  #         stylix.nixosModules.stylix
  #         nix-index-database.nixosModules.nix-index
  #         determinate.nixosModules.default
  #       ];
  #     };
  #   };
  #   darwinConfigurations."MacBook-Pro-user" = nix-darwin.lib.darwinSystem {
  #     specialArgs = {inherit inputs;};
  #     modules = [
  #       ./hosts/work/configuration.nix
  #       inputs.home-manager.darwinModules.home-manager
  #       {
  #         home-manager.useGlobalPkgs = true;
  #         home-manager.useUserPackages = true;
  #         home-manager.extraSpecialArgs = {inherit inputs;};
  #         home-manager.users.user = import ./hosts/work/home.nix;
  #       }
  #     ];
  #   };
  # };

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

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    paneru = {
      url = "github:karinushka/paneru";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae.url = "github:vicinaehq/vicinae";
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    tree-sitter.url = "github:tree-sitter/tree-sitter";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrappers.url = "github:Lassulus/wrappers";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}
