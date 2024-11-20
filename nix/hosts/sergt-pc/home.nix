{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.stylix.homeManagerModules.stylix
    ../../hardware/k02.nix
    ../../home/eww
    ../../home/nvim
    ../../home/rofi
    ../../home/shells/zsh.nix
    ../../home/themes/kanagawa.nix
    ../../home/waybar
  ];
  home.homeDirectory = "/home/sergtco";

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
  };

  wayland.windowManager.hyprland = {
    systemd.enable = true;
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  home.packages = with pkgs; [
    alacritty
    tmux
    yazi-unwrapped
    ueberzugpp
    playerctl
    telegram-desktop
    swaynotificationcenter
    blueberry
    hyprpicker
    grimblast
    vial
    onlyoffice-bin_latest
    swayimg
  ];

  programs.git = {
    enable = true;
    userName = "Ivan Nizelnik";
    userEmail = "iva.nizelnik@gmail.com";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file = {

    alacritty = {
      target = ".config/alacritty";
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/alacritty";
      recursive = true;
    };

    helix = {
      target = ".config/helix";
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/helix";
      recursive = true;
    };

    lf = {
      target = ".config/lf";
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/lf";
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

    wlogout = {
      target = ".config/wlogout";
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/wlogout";
      recursive = true;
    };

  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
