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
    ../../homeModules/terminal
    ../../homeModules/desktop/browser
    inputs.stylix.homeModules.stylix
  ];
  stylix = let
    themes = import ../../modules/themes/themes.nix {};
  in {
    enable = true;
    base16Scheme = themes.lackluster;
    fonts = {
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Apple Color Emoji";
      };
    };
  };
  programs.home-manager.enable = true;
  programs.rio = {
    enable = true;
    settings = {
      fonts.family = lib.mkForce "NerdMono Nerd Font Mono";
    };
  };
  home.stateVersion = "25.05";
}
