{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];
  stylix = {
    enable = true;
    image = ../../../wallpaper/mini-wave.jpg;
    base16Scheme = {
      scheme = "Lackluster dark";
      base00 = "#101010";
      base01 = "#080808";
      base02 = "#191919";
      base03 = "#2a2a2a";
      base04 = "#555555";
      base05 = "#deeeed";
      base06 = "#f0f0f0";
      base07 = "#ffffff";
      base08 = "#e64a6b";
      base09 = "#e69b7b";
      base0A = "#f0c674";
      base0B = "#789978";
      base0C = "#708090";
      base0D = "#7788AA";
      base0E = "#b86cd4";
      base0F = "#e64a6b";
    };

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
