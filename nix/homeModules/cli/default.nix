{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./tmux.nix
  ];

  home.packages = with pkgs; [
    ripgrep
    fd
    file
    usbutils
    ffmpeg
    imagemagick
    progress
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
      includes = [
        {
          path = "~/work/.gitconfig";
          condition = "gitdir:~/work/";
        }
      ];
    };
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };

  programs = {
    fzf.enable = true;
    yazi.enable = true;
    zoxide.enable = true;
  };
}
