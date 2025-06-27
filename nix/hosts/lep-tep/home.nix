{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../homeModules/cli
    ../../homeModules/destkop
    ../../homeModules/nvim
    ../../homeModules/shell/zsh.nix
    ../../homeModules/terminal
  ];
  home.homeDirectory = "/home/sergtco";

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "brave";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
  };

  home.packages = with pkgs; [
    playerctl
    lollypop
    telegram-desktop
    transmission_4-gtk
    hyprpicker
    grimblast
    vial
    onlyoffice-bin_latest
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
}
