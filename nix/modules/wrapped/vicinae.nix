{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: let
    json = pkgs.formats.json {};
    settings = {
      main = {
        pop_to_root_on_close = true;
        launcher_window = {
          layer_shell = {
            enabled = true;
            keyboard_interactivity = "exclusive";
            layer = "overlay";
          };
        };
        theme = {
          light.name = "stylix";
          light.icon_theme = "Tela-black-light";

          dark.name = "stylix";
          dark.icon_theme = "Tela-black-dark";
        };
        font.normal.size = 11;
        launcher_window.client_side_decorations.enabled = false;
        providers = {
          core.entrypoints.store.enabled = false;
        };
      };
    };
  in {
    packages.vicinae = inputs.wrapper-modules.lib.wrapPackage ({...}: {
      inherit pkgs;
      package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
      env = {
        HTTP_PROXY = "http://127.0.0.1:10809";
        HTTPS_PROXY = "http://127.0.0.1:10809";
        USE_LAYER_SHELL = "1";
        NODE_USE_ENV_PROXY = "1";
      };
    });
  };
}
