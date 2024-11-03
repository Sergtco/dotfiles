{
  config,
  pkgs,
  inputs,
  ...
}:
{
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

}
