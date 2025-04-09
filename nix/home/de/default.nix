{
  config,
  pkgs,
  ...
}: {
  services.udiskie.enable = true;

  services.swaync = {
    enable = true;
    settings = ../../../config/swaync/config.json;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      ${builtins.readFile ../../../config/hypr/hyprland.conf}
    '';
  };

  home.packages = with pkgs; [
    firefox
    pavucontrol
    vlc
    gedit
    swayimg
  ];

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = ["thunar.desktop"];
      "text/html" = ["firefox.desktop"];
      "text/plain" = ["org.gnome.gedit.desktop"];
    };
  };

  home.file = {
    tmux = {
      target = ".config/tmux";
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/tmux";
      recursive = true;
    };
  };

  home.file = {
    ".config/hypr/hypridle.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/hypr/hypridle.conf";
    ".config/hypr/hyprlock.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/hypr/hyprlock.conf";
  };
}
