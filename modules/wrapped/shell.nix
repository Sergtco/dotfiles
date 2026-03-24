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
        bindkey -v
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        source <(${lib.getExe pkgs.oh-my-posh} init zsh --config ${pkgs.oh-my-posh}/share/oh-my-posh/themes/pure.omp.json)
        source <(${lib.getExe pkgs.skim} --shell zsh)
        source ${pkgs.skim}/share/skim/key-bindings.zsh

        source <(${lib.getExe pkgs.direnv} hook zsh)
        source <(${lib.getExe pkgs.zoxide} init zsh)

        autoload -Uz compinit && compinit
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      '';

      extraPackages = with pkgs; [
        sesh
        skim
        direnv
        zoxide

        ripgrep
        fd
        bat
        file
        usbutils
        ffmpeg
        bottom
        imagemagick
        progress

        jq

        bash
        curl
        p7zip
        zip
        unzip
        rar
        killall
        wget

        yazi

        self'.packages.tmux
        self'.packages.neovimDynamic
        self'.packages.git
      ];

      env = {
        EDITOR = "${lib.getExe self'.packages.neovimDynamic}";
        MANPAGER = "${lib.getExe self'.packages.neovimDynamic} +Man!";
      };
    };
  };
}
