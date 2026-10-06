{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      # GMCA is a fork of switchfin, which nixpkgs already packages — same
      # borealis UI, same submodules, same cmake switches — so this is that
      # derivation pointed at the fork rather than a build written from
      # scratch. Upstream ships no plain Linux binary to wrap (only Arch,
      # flatpak, apk, dmg and 7z), hence building from source.
      packages.gmca = pkgs.switchfin.overrideAttrs (
        old:
        let
          version = "1.1.0";
        in
        {
          pname = "gmca";
          inherit version;

          src = pkgs.fetchFromGitHub {
            owner = "thcolin";
            repo = "gamepad-media-center-aggregator";
            tag = "v${version}";
            hash = "sha256-rVUBShtnWNFplXJMD8liR0aytx2RcE7+PP7ZIWm8Q5Q=";
            fetchSubmodules = true;
          };

          # Upstream's CI patches the borealis submodule before building —
          # see "Apply borealis patches" in .github/workflows/build.yaml. The
          # app calls APIs the pinned submodule does not have yet
          # (ScrollingFrame::setScrollingIndicatorVisibleGlobal,
          # BatteryWidget(float), ...), so without this the build dies at 65%.
          postPatch = ''
            patch -p1 -d library/borealis < scripts/patches/borealis-fixes.patch
          '';

          meta = old.meta // {
            description = "Gamepad media center aggregator for Plex, Jellyfin, Emby and Stremio";
            homepage = "https://github.com/thcolin/gamepad-media-center-aggregator";
            changelog = "https://github.com/thcolin/gamepad-media-center-aggregator/blob/v${version}/CHANGELOG.md";
            # cmake declares project(GMCA), so the binary is not Switchfin.
            mainProgram = "GMCA";
            maintainers = [ ];
          };
        }
      );
    };
}
