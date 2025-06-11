{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    ripgrep
    fd
    tmux
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

  programs = {
    fzf.enable = true;
    nix-index.enable = true;
    yazi.enable = true;
    zoxide.enable = true;
  };

  xdg.configFile.tmux = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/tmux";
    recursive = true;
  };
}
