{
  pkgs,
  lib,
  ...
}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.foot}/bin/foot";
      };
      colors = {
        border = lib.mkForce "080808FF";
      };
      border = {
        radius = 3;
      };
    };
  };
  home.packages = [
    pkgs.nerd-fonts.fira-code
    (pkgs.writeShellScriptBin "fuzzel-power" (builtins.readFile ./powermenu.sh))
  ];
}
