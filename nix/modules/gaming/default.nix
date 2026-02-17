{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.gaming;
in {
  options.custom.gaming = {
    extraPackages = lib.mkOption {
      type = (lib.types.listOf lib.types.package);
      default = [];
    };
  };
  config = {
    boot.initrd.kernelModules = [
      "xpad"
    ];

    programs.steam = {
      enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
      extraPackages = [
        pkgs.mangohud
      ];
    };

    programs.gamescope = {
      enable = true;
      args = ["-W1920" "-H1080" "--force-grab-cursor" "-f" "--force-composition"];
    };

    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs.unstable; [r2modman] ++ cfg.extraPackages;

    services.joycond.enable = true;
    services.udev.packages = [pkgs.game-devices-udev-rules];
    hardware.uinput.enable = true;

    home-manager.users.sergtco.programs.lutris = {
      enable = true;
      package = pkgs.lutris;
      protonPackages = [pkgs.proton-ge-bin];
      winePackages = with pkgs; [wine];
      extraPackages = with pkgs; [
        winetricks
        mangohud
        umu-launcher
        gamescope
        gamemode
      ];
    };
  };
}
