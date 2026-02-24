{pkgs, ...}: {
  home = {
    sessionVariables = {
      TERMINAL = "alacritty";
    };
  };
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty-graphics;
    settings = {
      window.dynamic_padding = true;
    };
  };
}
