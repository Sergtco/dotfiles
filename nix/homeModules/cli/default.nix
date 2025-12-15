{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./tmux.nix
    inputs.nix-index-database.homeModules.nix-index
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
      settings = {
        user = {
          name = "Ivan Nizelnik";
          email = "iva.nizelnik@gmail.com";
        };
        alias = {
          a = "add";
          sw = "switch";
          co = "checkout";
          cc = "commit";
          ca = "commit --amend";
          p = "push";
          f = "fetch";
          st = "status";
        };
        core = {
          editor = "nvim";
        };
        diff = {
          tool = "nvimdiff";
        };
        merge = {
          tool = "nvimdiff";
        };
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
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
  };
}
