{pkgs, ...}: {
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

  environment.systemPackages = with pkgs; [r2modman];

  services.joycond.enable = true;
  services.udev.packages = [pkgs.game-devices-udev-rules];
  hardware.uinput.enable = true;

  home-manager.users.sergtco.programs.lutris = {
    enable = true;
    package = pkgs.lutris;
    protonPackages = [pkgs.proton-ge-bin];
    winePackages = with pkgs; [wine wineWowPackages.stable];
    extraPackages = with pkgs; [
      winetricks
      mangohud
      umu-launcher
      gamescope
      gamemode
    ];
  };

  boot.initrd.kernelModules = [
    "xpad"
  ];
}
