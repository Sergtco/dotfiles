{
  pkgs,
  config,
  ...
}: {
  home = {
    sessionVariables = {
      TERMINAL = "ghostty";
    };
  };
  home.packages = [
    pkgs.unstable.ghostty
  ];

  home.file.".config/ghostty/" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/ghostty/";
    recursive = true;
  };
}
