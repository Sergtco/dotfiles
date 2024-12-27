{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../hardware/k02.nix
    ../../home/nvim
    ../../home/shells/zsh.nix
    ../../home/themes/kanagawa.nix
    ../../home/waybar
    ../../home/cli
    ../../home/anyrun
    ../../home/de
    ../../home/terminals/ghostty.nix
  ];
  home.homeDirectory = "/home/sergtco";

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
  };

  home.packages = with pkgs; [
    tmux
    playerctl
    rhythmbox
    pinta
    telegram-desktop
    transmission_4-gtk
    blueberry
    hyprpicker
    grimblast
    vial
    onlyoffice-bin_latest
    swayimg
    vesktop
  ];

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "inode/directory" = ["thunar.desktop"];
      "text/html" = ["firefox.desktop"];
      "text/plain" = ["org.gnome.gedit.desktop"];
    };
    defaultApplications = {
      "inode/directory" = ["thunar.desktop"];
      "text/html" = ["firefox.desktop"];
      "text/plain" = ["org.gnome.gedit.desktop"];
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
