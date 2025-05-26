{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../home/nvim
    ../../home/shells/zsh.nix
    ../../home/terminals
    ../../home/waybar
    ../../home/cli
    ../../home/rofi
    ../../home/de
  ];
  home.homeDirectory = "/home/sergtco";

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
  };

  home.packages = with pkgs; [
    tmux
    playerctl
    lollypop
    gimp
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
