{...}: {
  home = {
    sessionVariables = {
      TERMINAL = "alacritty";
    };
  };

  programs.alacritty = {
    enable = true;
  };
}
