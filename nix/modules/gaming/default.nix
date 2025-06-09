{pkgs, ...}: {
  programs.steam = {
    enable = true;

    gamescopeSession = {
      enable = true;
      steamArgs = [
        "-steamos3"
        "-gamepadui"
        "-pipewire-dmabuf"
      ];
    };
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

  hardware.xone.enable = true;
  hardware.xpadneo.enable = true;
}
