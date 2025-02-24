{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    ripgrep
    fd
    ueberzugpp
  ];

  programs = {
    git = {
      enable = true;
      userName = "Ivan Nizelnik";
      userEmail = "iva.nizelnik@gmail.com";
      aliases = {
        sw = "switch";
        co = "checkout";
        cm = "commit";
        st = "status";
      };
    };

    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file.tmux = {
    target = ".config/tmux";
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/tmux";
    recursive = true;
  };
}
