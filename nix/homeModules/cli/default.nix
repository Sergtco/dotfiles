{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-index-database.homeModules.nix-index
    ./tmux.nix
  ];
  home.packages = with pkgs; [
    ripgrep
    fd
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
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
  };
}
