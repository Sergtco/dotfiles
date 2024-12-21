{
  pkgs,
  config,
  ...
}: {
  home = {
    # sessionVariables = {
    #   TERMINAL = "alacritty";
    # };
  };

  home.packages = with pkgs; [
    wezterm
  ];
  xdg.configFile = {
    "wezterm/".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/wezterm";
  };
}
