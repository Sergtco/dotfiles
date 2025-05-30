{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.foot}/bin/foot";
    font = "Fira Code Nerd Font 14";
    extraConfig = {
      modes = "drun,calc,power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      sidebar-mode = true;
      display-drun = " ";
      display-window = " ";

      kb-row-up = "Up,Control+p";
      kb-row-left = "Left,Control+h";
      kb-row-right = "Right,Control+l";
      kb-row-down = "Down,Control+n";

      kb-accept-entry = "Control+y,Return,KP_Enter";

      kb-remove-to-eol = "";
      kb-move-char-back = "Control+b";
      kb-remove-char-back = "BackSpace";
      kb-move-char-forward = "Control+f";
      kb-mode-complete = "Control+o";
    };
    theme = ./lackluster.rasi;
    plugins = [
      pkgs.rofi-power-menu
      (pkgs.rofi-calc.override {rofi-unwrapped = pkgs.rofi-wayland-unwrapped;})
    ];
  };
  home.packages = [pkgs.nerd-fonts.fira-code];
}
