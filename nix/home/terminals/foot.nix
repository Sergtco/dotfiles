{...}: {
  home = {
    sessionVariables = {
      TERMINAL = "foot";
    };
  };
  programs.foot = {
    enable = true;
    settings = {
      cursor = {
        blink = true;
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
