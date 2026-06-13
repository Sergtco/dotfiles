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
      package = pkgs.unstable.throne;
      enable = true;
      tunMode.enable = true;
      # tunMode.setuid = true;
    };

    networking.nameservers = ["8.8.8.8" "8.8.4.4"];
  };
}
