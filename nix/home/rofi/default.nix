{
  pkgs,
  ...
}:

{
  programs.rofi = {
    enable = true;
    terminal = "alacritty";
    theme = ./kanagawa.rasi;
    package = pkgs.rofi-wayland;
    plugins = with pkgs; [ rofi-power-menu ];
    extraConfig = {
      modes = "window,drun,run,ssh,power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
      show-icons = true;
      display-drun = " ";
      display-run = " ";
      display-window = " ";
    };
  };
}
