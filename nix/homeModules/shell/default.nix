{config, ...}: {
  imports = [./zsh.nix];
  home.shellAliases = {
    v = "nvim";
    y = "yazi";
    d = "docker";
    dc = "docker compose";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.cargo/bin/"
    "${config.home.homeDirectory}/go/bin/"
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
