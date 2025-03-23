{config, ...}: {
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
