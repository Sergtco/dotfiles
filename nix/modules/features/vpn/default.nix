{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.vpn = {...}: {
    services.xray = {
      enable = true;
      settingsFile = "/etc/v2ray/v2ray_config.json";
    };
  };
}
