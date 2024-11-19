{ ... }:
{
  imports = [ ./oh_my_posh.nix ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion = {
      enable = true;
    };
    history.ignoreDups = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      nv = "nvim";
      tm = "tmux -a || tmux";
      yz = "yazi";
    };
    profileExtra = ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
    '';
  };
}
