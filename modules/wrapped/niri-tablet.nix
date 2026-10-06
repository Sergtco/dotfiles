{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      self',
      lib,
      ...
    }:
    let
      # The fork ships as a patch series rebased onto a niri release rather
      # than a buildable tree, so it goes on top of nixpkgs' niri. The series
      # tracks upstream tags: when nixpkgs moves past the tag it is rebased on
      # (`_tag` in the fork's pkg/PKGBUILD), expect patches to stop applying.
      patchDir = "${inputs.niri-tablet}/pkg";
      patches = lib.pipe (builtins.readDir patchDir) [
        (lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".patch" name))
        builtins.attrNames
        (lib.sort (a: b: a < b))
        (map (name: "${patchDir}/${name}"))
      ];
      package = pkgs.unstable.niri.overrideAttrs (old: {
        pname = "niri-tablet";
        patches = (old.patches or [ ]) ++ patches;
      });
    in
    {
      # The regular niri config, plus the fork's `gestures` block.
      packages.niri-tablet = self'.packages.niri.wrap {
        package = lib.mkForce package;
        settings.gestures = {
          touchscreen-swipe = {
            fingers = 3;
            horizontal-swipe = "resize-column";
            tap.maximize-column = (_: { });
            tap-more.toggle-overview = (_: { });
            swipe-more-down.close-window = (_: { });
            swipe-more-up.fullscreen-window = (_: { });
            hold = {
              left.move-column-left = (_: { });
              right.move-column-right = (_: { });
              up.move-window-to-workspace-up = (_: { });
              down.move-window-to-workspace-down = (_: { });
            };
          };

          touchscreen-edge-swipe = {
            top.toggle-overview = (_: { });
            left.focus-column-left = (_: { });
            right.focus-column-right = (_: { });
          };

          # One finger swiped diagonally inward from any corner.
          touchscreen-corner-swipe =
            lib.genAttrs [ "top-left" "top-right" "bottom-left" "bottom-right" ]
              (_: {
                spawn = [
                  "vicinae"
                  "toggle"
                ];
              });
        };
      };
    };
}
