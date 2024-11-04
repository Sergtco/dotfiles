{
  config,
  pkgs,
  inputs,
  ...
}:

let
  unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
  };
in
{
  imports = [
    inputs.stylix.homeManagerModules.stylix
    ../../home/themes/kanagawa.nix
    ../../home/rofi/rofi.nix
    ../../home/shells/zsh.nix
    ../../home/waybar/waybar.nix
    ../../home/nvim/nvim.nix
    ../../home/terminals/rio.nix
  ];
  home.homeDirectory = "/home/sergtco";

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
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
    yazi
    playerctl
    telegram-desktop
    swaynotificationcenter
    blueberry
    hyprpicker
    grimblast
    vial
    libreoffice
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
