{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../homeModules/cli
    ../../homeModules/desktop
    ../../homeModules/nvim
    ../../homeModules/shell/zsh.nix
    ../../homeModules/terminal
  ];
  home.homeDirectory = "/home/sergtco";

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
  };

  home.packages = with pkgs; [
    playerctl
    telegram-desktop
    transmission_4-gtk
    hyprpicker
    grimblast
    vial
    libreoffice-fresh
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
}
