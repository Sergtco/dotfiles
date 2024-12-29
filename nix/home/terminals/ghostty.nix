{
  inputs,
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
    inputs.ghostty.packages.${pkgs.system}.ghostty
  ];

  home.file.".config/ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/ghostty/config";
}
