{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.stylix.homeManagerModules.stylix];

  stylix = {
    enable = true;
    image = ../../../wallpaper/mini-wave.jpg;
    base16Scheme = ./kanagawa.yaml;
    polarity = "dark";
    cursor = {
      name = "Hackneyed";
      size = 24;
      package = pkgs.hackneyed;
    };
    fonts = {
      monospace = {
        name = "FiraCode Nerd Font Mono";
        package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
      };
      sizes = {
        terminal = 16;
        desktop = 14;
      };
    };
    targets = {
      firefox.enable = true;
      yazi.enable = true;
      rofi.enable = false;
      waybar.enable = false;
    };
  };
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.kanagawa-icon-theme;
      name = "Kanagawa";
    };
  };
  qt = {
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
}
