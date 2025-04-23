{pkgs, ...}: {
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };

  programs.gamescope = {
    enable = true;
    capSysNice = false;
    args = [
      "-w 1920"
      "-h 1080"
      "-f"
      "-r 165"
    ];
  };

  programs.gamemode = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    lutris
    r2modman
    unstable.umu-launcher
  ];

  boot.initrd.kernelModules = [
    "xpad"
  ];

  hardware.xone.enable = true;
  hardware.xpadneo.enable = true;
}
