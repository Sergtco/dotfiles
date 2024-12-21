{config, ...}: {
  home = {
    sessionVariables = {
      TERMINAL = "alacritty";
    };
  };

  programs.alacritty = {
    enable = true;
  };
  home.file.alacritty = {
    target = ".config/alacritty";
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/alacritty";
    recursive = true;
  };
}
