{...}: {
  home.shell.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
    history.ignoreDups = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      nv = "nvim";
      d = "docker";
      dc = "docker compose";
    };

    initContent = ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
    '';
  };

  home.sessionPath = [
    "/home/sergtco/.cargo/bin/"
    "/home/sergtco/go/bin/"
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.hide_env_diff = true;
    };

    oh-my-posh = {
      enable = true;
      useTheme = "pure";
    };
  };
}
