{
  pkgs,
  inputs,
  ...
}: let
  themes = (import ./themes.nix) {};
in {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];
  stylix = {
    enable = true;
    image = ../../../wallpaper/mini-wave-white.jpg;
    base16Scheme = themes.lackluster;

    cursor = {
      name = "Hackneyed";
      size = 24;
      package = pkgs.hackneyed;
    };

    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme.override {
        color = "black";
      };
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
        name = "FiraCode Nerd Font Mono";
      };
    };

    targets = {
      waybar.enable = false;
      rofi.enable = false;
    };
  };
}
