{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.vpn = {pkgs, ...}: {
    services.xray = {
      enable = true;
      settingsFile = "/etc/v2ray/v2ray_config.json";
    };
    programs.throne = {
      enable = true;
      package = pkgs.unstable.throne;
      tunMode.enable = true;
      tunMode.setuid = true;
    };
    networking.nameservers = ["1.1.1.1" "8.8.8.8" "8.8.4.4"];
  };
}
