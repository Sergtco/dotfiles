{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
      user = config.preferences.user.name;
      mkBaseService = command: {
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = command;
          ExecReload = "/user/bin/env kill -HUP $MAINPID";
          Restart = "always";
          RestartSec = "60";
          KillMode = "process";
        };
      };
    in
    {
      systemd.user.services = {
        wlsunset = mkBaseService "${lib.getExe pkgs.wlsunset} -S 7:00 -s 22:00";
        hyprpolkitagent = mkBaseService "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
        swaybg = mkBaseService "${lib.getExe pkgs.swaybg} -i ${../../../wallpaper/dayspring_by_bisbiswas.jpg}";
        fnott = mkBaseService "${lib.getExe selfpkgs.fnott}";
        swayosd = mkBaseService "${pkgs.swayosd}/bin/swayosd-server";
      };
    };
}
