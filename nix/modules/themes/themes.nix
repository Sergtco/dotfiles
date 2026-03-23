{...}: let
  theme = {
    scheme = "Lackluster dark";
    base00 = "#101010";
    base01 = "#191919";
    base02 = "#2a2a2a";
    base03 = "#444444";
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
  stripHash = str:
    if builtins.substring 0 1 str == "#"
    then builtins.substring 1 (builtins.stringLength str - 1) str
    else str;
  themeNoHash = builtins.mapAttrs (_: v: stripHash v) theme;
in {
  flake = {
    inherit theme themeNoHash;

    nixosModules.theme = {pkgs, lib, ...}: let
      icon-theme-package = pkgs.tela-icon-theme;
      icon-theme-name = "Tela-black-dark";
      theme-name = "Adwaita-dark";
      gtksettings = ''
        gtk-icon-theme-name = ${icon-theme-name}
        gtk-theme-name = ${theme-name}
      '';
    in {
      qt = {
        enable = true;
        style = "adwaita-dark";
      };
      environment = {
        etc = {
          "xdg/gtk-3.0/settings.ini".text = gtksettings;
          "xdg/gtk-4.0/settings.ini".text = gtksettings;
        };
      };
      environment.sessionVariables = {
        GTK_THEME = theme-name;
      };
      programs.dconf = {
        enable = lib.mkDefault true;
        profiles = {
          user.databases = [
            {
              lockAll = false;
              settings = {
                "org/gnome/desktop/interface" = {
                  gtk-theme = theme-name;
                  icon-theme = icon-theme-name;
                  color-scheme = "prefer-dark";
                };
              };
            }
          ];
        };
      };
    };
  };
}
