{pkgs, ...}: {
  programs.steam.enable = true;

  programs.gamescope.enable = true;

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    (lutris.override {
      extraPkgs = pkgs: [
        wineWowPackages.stable
        wine
        winetricks
        mangohud
        umu-launcher
      ];
    })
    protonplus
  ];

  boot.initrd.kernelModules = [
    "xpad"
  ];

  hardware.xone.enable = true;
  hardware.xpadneo.enable = true;
}
