{pkgs, ...}: {
  programs.steam = {
    enable = true;
  };

  programs.gamescope = {
    enable = true;
    args = [
      "-W 1920"
      "-H 1080"
      "-f"
      "--force-grab-cursor"
      "-r 165"
    ];
  };

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
    r2modman
    protonplus
  ];

  boot.initrd.kernelModules = [
    "xpad"
  ];
}
