{pkgs, ...}: {
  home = {
    sessionVariables = {
      TERMINAL = "alacritty";
    };
  };
  xdg.terminal-exec.enable = true;
  xdg.terminal-exec.settings.default = ["alacritty.desktop"];
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty-graphics;
    settings = {
      window.dynamic_padding = true;
    };
  };
}
