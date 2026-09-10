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
    xwayland-satellite = (
      final: prev: {
        xwayland-satellite = prev.xwayland-satellite.overrideAttrs (old: rec {
          version = "0.8.1";
          src = final.fetchFromGitHub {
            owner = "Supreeeme";
            repo = "xwayland-satellite";
            tag = "v${version}";
            hash = "sha256-BUE41HjLIGPjq3U8VXPjf8asH8GaMI7FYdgrIHKFMXA=";
          };
          cargoDeps = final.rustPlatform.fetchCargoVendor {
            inherit src;
            hash = "sha256-16L6gsvze+m7XCJlOA1lsPNELE3D364ef2FTdkh0rVY=";
          };
          doInstallCheck = false;
        });
      }
    );
  };
}
