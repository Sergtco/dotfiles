{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: let
    # "ASUS Aura SMBus Motherboard" sweeps every i2c bus, including the AMDGPU
    # DP AUX ones where the probes time out. It registers no controller on this
    # board and cost ~6.2s of a 7.7s detection run; the USB "ASUS Aura
    # Motherboard" detector finds the board instead. Detectors left unlisted
    # here stay enabled.
    settings = (pkgs.formats.json {}).generate "OpenRGB.json" {
      Detectors.detectors."ASUS Aura SMBus Motherboard" = false;
    };
    # --config takes a directory. openrgb wants to rewrite its settings on exit
    # and simply carries on when it cannot, which is what keeps this declarative.
    configDir = pkgs.runCommand "openrgb-config" {} ''
      mkdir -p $out
      cp ${settings} $out/OpenRGB.json
    '';
  in {
    packages.openrgb = inputs.wrapper-modules.lib.wrapPackage ({...}: {
      inherit pkgs;
      package = pkgs.unstable.openrgb;
      flags = {
        "--config" = configDir;
      };
    });
  };

  flake.nixosModules.no-rgb = {pkgs, ...}: let
    openrgb = self.packages.${pkgs.stdenv.hostPlatform.system}.openrgb;
  in {
    services.udev.packages = [pkgs.unstable.openrgb];
    boot.kernelModules = ["i2c-dev"];
    hardware.i2c.enable = true;

    systemd.services.no-rgb = {
      description = "no-rgb";
      serviceConfig = {
        ExecStart = "${openrgb}/bin/openrgb --noautoconnect --mode static --color 000000";
        Type = "oneshot";
      };
      # After= on the target it is wanted by, so the openrgb device scan runs
      # alongside the session instead of gating graphical.target.
      wantedBy = ["multi-user.target"];
      after = ["multi-user.target"];
    };
  };
}
