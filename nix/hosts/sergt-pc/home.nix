{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../homeModules/cli
    ../../homeModules/desktop
    ../../homeModules/nvim
    ../../homeModules/shell
    ../../homeModules/terminal
  ];
  home.homeDirectory = "/home/sergtco";

  home.sessionVariables = {
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
  };

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
}
