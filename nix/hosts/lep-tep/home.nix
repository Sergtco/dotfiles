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
    ../../home/terminals/alacritty.nix
    ../../home/waybar
    ../../home/cli
    ../../home/anyrun
  ];
  home.homeDirectory = "/home/sergtco";

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
  };

  home.packages = with pkgs; [
    alacritty
    tmux
    playerctl
    rhythmbox
    pinta
    telegram-desktop
    transmission_4-gtk
    swaynotificationcenter
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

  home.file = {
    alacritty = {
      target = ".config/alacritty";
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/alacritty";
      recursive = true;
    };

    hypr = {
      target = ".config/hypr";
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/hypr";
      recursive = true;
    };

    swaync = {
      target = ".config/swaync";
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/swaync";
      recursive = true;
    };

    tmux = {
      target = ".config/tmux";
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/tmux";
      recursive = true;
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
