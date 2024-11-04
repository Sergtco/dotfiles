{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ./oh_my_posh.nix ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting.enable = true;

    shellAliases = {
      nv = "nvim";
      tm = "tmux -a || tmux";
      yz = "yazi";
    };
  };
}
