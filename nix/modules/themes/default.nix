{pkgs, ...}: let
  themes = (import ./themes.nix) {};
in {
  stylix = {
    enable = true;
    image = ../../../wallpaper/mini-wave-white.jpg;
    base16Scheme = themes.lackluster;
    polarity = "dark";

    cursor = {
      name = "Hackneyed";
      size = 24;
      package = pkgs.hackneyed;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
      };
    };
  };
  home-manager.users.sergtco.stylix = {
    enable = true;

    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme.override {
        color = "black";
      };
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    targets = {
      waybar.enable = false;
      rofi.enable = false;
    };
  };
}
