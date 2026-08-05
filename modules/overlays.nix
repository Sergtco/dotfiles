{ inputs, ... }:
{
  flake.overlays = {
    unstable = final: _: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final.stdenv.hostPlatform) system;
        inherit (final) config;
      };
    };

    nur = inputs.nur.overlays.default;
  };
}
