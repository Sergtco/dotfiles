{
  description = "Sergtco's flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Steam Deck (SteamOS userland, Valve's kernel). Upstream only validates
    # against nixos-unstable, hence the follows and the steamdeck host being
    # built from `nixpkgs-unstable`.
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Declarative partitioning, used by the steamdeck host: the machines that
    # predate it were installed by hand and keep their generated fileSystems.
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Touchscreen-gesture patchset for niri, applied on top of nixpkgs' niri
    # for the steamdeck host. Only its `pkg/*.patch` series is used.
    niri-tablet = {
      url = "github:GGEZUS/niri-tablet";
      flake = false;
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
