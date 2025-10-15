{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../homeModules/nvim
    ../../homeModules/shell/zsh.nix
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
  home.stateVersion = "25.05";
}
