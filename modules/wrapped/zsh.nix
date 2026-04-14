{
  self,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.zsh = inputs.wrapper-modules.wrappers.zsh.wrap {
      inherit pkgs;
      zshAliases = {
        v = "nvim";
        y = "yazi";
        d = "docker";
        dc = "docker compose";
        g = "git";
      };

      zshenv.content = ''
        path+=$HOME/.cargo/bin/
        path+=$HOME/go/bin/
      '';

      zshrc.content = ''
        bindkey -v
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        source <(${lib.getExe pkgs.oh-my-posh} init zsh --config ${pkgs.oh-my-posh}/share/oh-my-posh/themes/pure.omp.json)
        source <(${lib.getExe pkgs.fzf} --zsh)

        source <(${lib.getExe pkgs.direnv} hook zsh)
        source <(${lib.getExe pkgs.zoxide} init zsh)

        autoload -Uz compinit && compinit
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      '';
    };
  };
}
