{
  pkgs,
  ...
}: {
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };

  programs.gamemode = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    (lutris.override {
      extraPkgs = pkgs: [
        wineWowPackages.stable
        wineWowPackages.waylandFull
        wine
        winetricks
      ];
    })
    mangohud
    r2modman
    unstable.umu-launcher
  ];

  hardware.xone.enable = true;
  hardware.xpadneo.enable = true;
}
