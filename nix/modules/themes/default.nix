{pkgs, ...}: let
  themes = (import ./themes.nix) {};
in {
  stylix = {
    enable = true;
    image = ../../../wallpaper/nixos.jpg;
    base16Scheme = themes.lackluster;
    polarity = "dark";

    cursor = {
      name = "Hackneyed";
      size = 24;
      package = pkgs.hackneyed;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.zed-mono;
        name = "ZedMono Nerd Font Mono";
      };
      sizes.desktop = 13;
      sizes.terminal = 13;
      sizes.popups = 14;
    };
  };

  home-manager.users.sergtco.stylix = {
    enable = true;

    iconTheme = {
      enable = true;
      package = pkgs.tela-icon-theme;
      dark = "Tela-black-dark";
      light = "Tela-black-light";
    };

    targets = {
      waybar.enable = false;
      firefox.enable = false;
    };
  };
}
