{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.gaming =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      boot.initrd.kernelModules = [
        "xpad"
      ];

      programs.steam = {
        enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
        extraPackages = [
          pkgs.mangohud
        ];
      };

      programs.gamescope = {
        enable = true;
        args = [
          "-W1920"
          "-H1080"
          "--force-grab-cursor"
          "-f"
          "--force-composition"
        ];
      };

      programs.gamemode.enable = true;

      services.joycond.enable = true;
      services.udev.packages = [ pkgs.game-devices-udev-rules ];
      hardware.uinput.enable = true;
      environment.systemPackages = with pkgs; [
        r2modman
        (pkgs.unstable.lutris.override {
          extraPkgs = pkgs: with pkgs; [
            proton-ge-bin
            wine
            winetricks
            mangohud
            umu-launcher
            gamescope
            gamemode
          ];
        })
      ];
    };
}
