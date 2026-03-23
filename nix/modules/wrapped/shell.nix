{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, self', ...}: {
    packages.shell = inputs.wrapper-modules.wrappers.zsh.wrap {
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
        eval "$(oh-my-posh init zsh --config pure)"
        source <(sk --shell zsh)
        source ${pkgs.skim}/share/skim/key-bindings.zsh
        eval "$(direnv hook zsh)"
        eval "$(zoxide init zsh)"
      '';

      extraPackages = with pkgs; [
        skim
        direnv
        zoxide
        oh-my-posh
        sesh

        ripgrep
        fd
        bat
        file
        usbutils
        ffmpeg
        imagemagick
        progress

        yazi
         
        self'.packages.tmux
        self'.packages.nvim
        self'.packages.git
      ];
    };
  };
}
