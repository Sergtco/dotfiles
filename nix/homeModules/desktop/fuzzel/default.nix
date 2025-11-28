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
        dpi-aware = "no";
      };
      border = {
        radius = 0;
      };
    };
  };
  home.packages = [
    pkgs.nerd-fonts.fira-code
    (pkgs.writeShellScriptBin "fuzzel-power" (builtins.readFile ./powermenu.sh))
    (pkgs.writeShellScriptBin "dmenu" ''
      #!/usr/bin/env bash
      fuzzel --dmenu "$@"
    '')
  ];
}
