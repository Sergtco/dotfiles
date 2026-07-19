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
      boot.kernelModules = [ "ntsync" ];

      programs.steam = {
        enable = true;
        package = pkgs.steam.override {
          extraProfile = ''
            export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
          '';
        };
        extraCompatPackages = [ pkgs.unstable.proton-ge-bin ];
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
        (pkgs.lutris.override {
          extraPkgs =
            pkgs: with pkgs; [
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

      programs.corectrl.enable = true;
    };
}
