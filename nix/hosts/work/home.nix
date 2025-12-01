{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../homeModules/nvim
    ../../homeModules/shell
    ../../homeModules/cli
    ../../homeModules/desktop/browser
    inputs.stylix.homeModules.stylix
  ];
  stylix = let
    themes = import ../../modules/themes/themes.nix {};
  in {
    enable = true;
    base16Scheme = themes.lackluster;
  };
  programs.home-manager.enable = true;
  programs.rio = {
    enable = true;
    settings = {
      fonts.family = lib.mkForce "FiraCode Nerd Font Mono";
    };
  };
  home.stateVersion = "25.05";
}
