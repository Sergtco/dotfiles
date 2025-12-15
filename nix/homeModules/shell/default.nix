{config, ...}: {
  imports = [./zsh.nix];
  home.shellAliases = {
    v = "nvim";
    vv = "nvim +FzfLua\\ files";
    vg = "nvim +FzfLua\\ live_grep";
    y = "yazi";
    d = "docker";
    dc = "docker compose";
    g = "git";
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
