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
        font = lib.mkForce "ZedMono Nerd Font Mono";
      };
      border = {
        radius = 0;
      };
    };
  };
  home.packages = [
    (pkgs.writeShellScriptBin "fuzzel-power" (builtins.readFile ./powermenu.sh))
    (pkgs.writeShellScriptBin "dmenu" ''
      #!/usr/bin/env bash
      fuzzel --dmenu "$@"
    '')
  ];
}
