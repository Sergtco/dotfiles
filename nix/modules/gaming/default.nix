{pkgs, ...}: {
  programs.steam = {
    enable = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
  };

  programs.gamescope = {
    enable = true;
    args = ["-W1920" "-H1080" "-r165" "-f" "--force-grab-cursor"];
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [r2modman];

  home-manager.users.sergtco.programs.lutris = {
    enable = true;
    protonPackages = [pkgs.proton-ge-bin];
    winePackages = with pkgs; [wine wineWowPackages.stable];
    extraPackages = with pkgs; [
      winetricks
      mangohud
      umu-launcher
      unstable.gamescope
      gamemode
    ];
  };

  boot.initrd.kernelModules = [
    "xpad"
  ];
}
