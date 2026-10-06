{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      # GloriousEggroll's CLI for adding non-Steam shortcuts. Worth having on a
      # Deck: Gaming Mode cannot browse the filesystem, so the alternative is
      # hand-editing shortcuts.vdf or doing it from Desktop Mode with a
      # keyboard. It hands Steam a steam:// URL rather than writing the file
      # behind its back, so no restart is needed.
      packages.steam-add-nonsteam-game = pkgs.callPackage (
        {
          lib,
          stdenvNoCC,
          fetchFromGitHub,
          python3,
        }:
        stdenvNoCC.mkDerivation (finalAttrs: {
          pname = "steam-add-nonsteam-game";
          version = "0-unstable-2026-07-25";

          src = fetchFromGitHub {
            owner = "GloriousEggroll";
            repo = "steam-add-nonsteam-game";
            rev = "07c42dc28878956fe98b4b388307276c51184448";
            hash = "sha256-oRRR9zLqNhoNn5rJ/KuM7YHTH0KHyleyPsgAcFGPIwk=";
          };

          # buildInputs, not nativeBuildInputs: patchShebangs --host resolves
          # the interpreter from HOST_PATH, which only carries buildInputs, so
          # `#!/usr/bin/env python3` is left alone otherwise. The script itself
          # imports nothing outside the standard library.
          buildInputs = [ python3 ];

          installPhase = ''
            runHook preInstall
            install -Dm755 steam-add-nonsteam-game $out/bin/steam-add-nonsteam-game
            runHook postInstall
          '';

          # Deliberately not wrapped with a `steam` on PATH: it looks Steam up
          # at runtime (or takes STEAM_ADD_NONSTEAM_STEAM), and wrapping would
          # drag a second Steam FHS closure in beside the system one.
          meta = {
            description = "CLI tool to add non-Steam games or applications to Steam";
            homepage = "https://github.com/GloriousEggroll/steam-add-nonsteam-game";
            # Upstream ships no license file.
            license = lib.licenses.unfree;
            mainProgram = "steam-add-nonsteam-game";
            platforms = lib.platforms.linux;
          };
        })
      ) { };
    };
}
