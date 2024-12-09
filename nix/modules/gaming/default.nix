{pkgs, ...}: {
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };

  programs.gamemode = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    (unstable.lutris.override {
      extraPkgs = pkgs: [
        wineWowPackages.stable
        wine
        winetricks
      ];
    })
    mangohud
    r2modman
  ];
}
