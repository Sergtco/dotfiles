{
  config,
  ...
}: {
  imports = [
    ./wlogout.nix
  ];
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
  services.hyprpaper.enable = true;
  home.file = {
    alacritty = {
      target = ".config/alacritty";
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/alacritty";
      recursive = true;
    };

    tmux = {
      target = ".config/tmux";
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/tmux";
      recursive = true;
    };

    ".config/hypr/hypridle.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/hypr/hypridle.conf";
    ".config/hypr/hyprlock.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/hypr/hyprlock.conf";
  };
}
