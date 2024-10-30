{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.homeDirectory = "/home/sergtco";
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };

    shellAliases = {
      nv = "nvim";
      tm = "tmux -a || tmux";
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "Kanagawa-BL";
      package = pkgs.kanagawa-gtk-theme;
    };
    cursorTheme = {
      name = "Banana";
      package = pkgs.banana-cursor;
    };
    iconTheme = {
      name = "Kanagawa";
      package = pkgs.kanagawa-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
  home.pointerCursor = {
    name = "Banana";
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.banana-cursor;
  };

  home.packages = with pkgs; [
    alacritty
    tmux
    yazi
    rofi-wayland
    waybar
    wlogout
    telegram-desktop
    swaynotificationcenter
    blueberry
    lutris
    hyprpicker
    grimblast
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
    nvim = {
      target = ".config/nvim";
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim";
      recursive = true;
    };
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

    rofi = {
      target = ".config/rofi";
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/rofi";
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

    waybar = {
      target = ".config/waybar";
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/waybar";
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
