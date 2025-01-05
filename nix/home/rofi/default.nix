{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.unstable.ghostty}/bin/ghostty";
    font = "JetBrainsMono Nerd Font 14";
    extraConfig = {
      modi = "drun,calc,power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      sidebar-mode = false;
      display-drun = " ";
      display-run = " ";
      display-window = " ";

      kb-row-up = "Up,Control+p";
      kb-row-left = "Left,Control+h";
      kb-row-right = "Right,Control+l";
      kb-row-down = "Down,Control+n";

      kb-accept-entry = "Control+z,Control+y,Return,KP_Enter";

      kb-remove-to-eol = "";
      kb-move-char-back = "Control+b";
      kb-remove-char-back = "BackSpace";
      kb-move-char-forward = "Control+f";
      kb-mode-complete = "Control+o";
    };
    theme = ./kanagawa.rasi;
    plugins = [
      pkgs.rofi-power-menu
      (pkgs.rofi-calc.override {rofi-unwrapped = pkgs.rofi-wayland-unwrapped;})
    ];
  };
}
