{
  config,
  pkgs,
  inputs,
  ...
}:

{
  programs.rofi = {
    enable = true;
    terminal = "alacritty";
    theme = ./kanagawa.rasi;
    package = pkgs.rofi-wayland;
    extraConfig = {
      show-icons = true;
      display-drun = " ";
      display-run = " ";
      display-window = " ";
    };
  };
  }
