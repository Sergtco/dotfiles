{...}: {
  flake.nixosModules.no-rgb = {pkgs, ...}: let
    openrgb = pkgs.unstable.openrgb;
    # "ASUS Aura SMBus Motherboard" sweeps every i2c bus, including the AMDGPU
    # DP AUX ones where the probes time out. It registers no controller on this
    # board and cost ~6.2s of a 7.7s detection run; the USB "ASUS Aura
    # Motherboard" detector finds the board instead. Detectors left unlisted
    # here stay enabled.
    settings = (pkgs.formats.json {}).generate "OpenRGB.json" {
      Detectors.detectors."ASUS Aura SMBus Motherboard" = false;
    };
  in {
    services.udev.packages = [openrgb];
    boot.kernelModules = ["i2c-dev"];
    hardware.i2c.enable = true;

    systemd.services.no-rgb = {
      description = "no-rgb";
      serviceConfig = {
        # Since 1.0 openrgb creates <config>/logs on startup and aborts when it
        # cannot, so the config dir has to be writable. The settings are copied
        # over on every start, which keeps them declarative even though openrgb
        # rewrites the file on exit.
        StateDirectory = "no-rgb";
        ExecStartPre = "${pkgs.coreutils}/bin/install -m 644 ${settings} /var/lib/no-rgb/OpenRGB.json";
        ExecStart = "${openrgb}/bin/openrgb --config /var/lib/no-rgb --noautoconnect --mode static --color 000000";
        Type = "oneshot";
      };
      # After= on the target it is wanted by, so the openrgb device scan runs
      # alongside the session instead of gating graphical.target.
      wantedBy = ["multi-user.target"];
      after = ["multi-user.target"];
    };
  };
}
