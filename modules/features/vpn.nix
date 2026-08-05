_: {
  flake.nixosModules.vpn = { pkgs, ... }: {
    services.xray = {
      enable = true;
      settingsFile = "/etc/v2ray/v2ray_config.json";
    };

    programs.throne = {
      package = pkgs.throne;
      enable = true;
      tunMode.enable = true;
      tunMode.setuid = true;
    };

    services.resolved.enable = true;
  };
}
