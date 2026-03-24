{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.alacritty = inputs.wrapper-modules.wrappers.alacritty.wrap {
      inherit pkgs;
      package = pkgs.alacritty-graphics;
      settings = {
        font.normal.family = "ZedMono Nerd Font Mono";
        font.size = 13;
        window.dynamic_padding = true;
        mouse.hide_when_typing = true;
        colors = {
          primary.background = "#101010";
          normal = {
            black = "#080808";
            red = "#D70000";
            green = "#789978";
            yellow = "#ffAA88";
            blue = "#7788AA";
            magenta = "#D7007D";
            cyan = "#708090";
            white = "#DEEEED";
          };
        };
      };
    };
  };
}
