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
        eval "$(${lib.getExe pkgs.oh-my-posh} init zsh --config pure)"
        source <(${lib.getExe pkgs.skim} --shell zsh)
        source ${pkgs.skim}/share/skim/key-bindings.zsh

        eval "$(${lib.getExe pkgs.direnv} hook zsh)"
        eval "$(${lib.getExe pkgs.zoxide} init zsh)"
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
        killall
        wget

        yazi

        self'.packages.tmux
        self'.packages.neovim
        self'.packages.git
      ];
    };
  };
}
