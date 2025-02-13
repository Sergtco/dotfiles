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
      author = "PsyNyde/Studytce(oc)";
      base00 = "#101010"; # background
      base01 = "#080808"; # (Black)
      base02 = "#191919"; # (Bright Black)
      base03 = "#2a2a2a"; # (gray)
      base04 = "#555555"; # (Light gray)
      base05 = "#deeeed"; # foreground/luster
      base06 = "#f0f0f0"; # (Light foreground)
      base07 = "#ffffff"; # (Lightest Foreground)
      base08 = "#e64a6b"; # (Bright red) *modified*
      base09 = "#e69b7b"; # (Orange) *modified*
      base0A = "#f0c674"; # (Yellow) *modified*
      base0B = "#789978"; # (Green)
      base0C = "#708090"; # (cyan/Lack) *modified*
      base0D = "#7788AA"; # (Blue)
      base0E = "#b86cd4"; # (magenta) *modified*
      base0F = "#e64a6b"; # (Dark red) *modified*
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
