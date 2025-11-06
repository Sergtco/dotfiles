{pkgs, ...}: let
  no-rgb = pkgs.writeScriptBin "no-rgb" ''
    #!/bin/sh
    ${pkgs.unstable.openrgb}/bin/openrgb --noautoconnect --mode static --color 000000
  '';
in {
  config = {
    services.udev.packages = [pkgs.unstable.openrgb];
    boot.kernelModules = ["i2c-dev"];
    hardware.i2c.enable = true;

    systemd.services.no-rgb = {
      description = "no-rgb";
      serviceConfig = {
        ExecStart = "${no-rgb}/bin/no-rgb";
        Type = "oneshot";
      };
      wantedBy = ["default.target"];
    };
  };
}
