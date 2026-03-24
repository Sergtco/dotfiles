{inputs, ...}: {
  config = {
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];

    perSystem = {system, ...}: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.nur.overlays.default
          (final: _: {
            unstable = import inputs.nixpkgs-unstable {
              inherit (final.stdenv.hostPlatform) system;
              inherit (final) config;
            };
          })
        ];
        config = {
          allowUnfree = true;
        };
      };
    };
  };
}
