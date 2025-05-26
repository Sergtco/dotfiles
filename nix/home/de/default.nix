{
  config,
  pkgs,
  ...
}: {
  services = {
    udiskie.enable = true;

    swaync = {
      enable = true;
      settings = ../../../config/swaync/config.json;
    };

    swayosd.enable = true;
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
    eog
    wdisplays
    brightnessctl
  ];

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

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = ["thunar.desktop"];
      "application/pdf" = ["firefox.destkop"];

      "text/html" = ["firefox.desktop"];
      "text/plain" = ["nvim.desktop"];
      "text/markdown" = ["nvim.desktop"];

      "video/*" = ["vlc.desktop"];
      "video/mp4" = ["vlc.desktop"];
      "video/x-matroska" = ["vlc.desktop"];
      "image/*" = ["org.nomacs.ImageLounge.desktop"];

      "image/png" = ["org.nomacs.ImageLounge.desktop"];
      "image/jpeg" = ["org.nomacs.ImageLounge.desktop"];
      "image/gif" = ["org.nomacs.ImageLounge.desktop"];
    };
  };
}
