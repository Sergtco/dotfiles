{pkgs, ...}: {
  home.packages = with pkgs; [
    ripgrep
    fd
    ueberzugpp
  ];
  programs = {
    git = {
      enable = true;
      userName = "Ivan Nizelnik";
      userEmail = "iva.nizelnik@gmail.com";
      aliases = {
        sw = "switch";
        co = "checkout";
        cm = "commit";
        st = "status";
      };
    };

    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.yazi.overrideAttrs (final: prev: {
      postInstall = ''
        installShellCompletion --cmd yazi \
          --bash ./yazi-boot/completions/yazi.bash \
          --fish ./yazi-boot/completions/yazi.fish \
          --zsh  ./yazi-boot/completions/_yazi

        install -Dm444 assets/logo.png $out/share/pixmaps/yazi.png
      '';
    });
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
