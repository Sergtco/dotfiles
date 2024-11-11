{
  pkgs,
  ...
}:
{
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };
  programs.gamemode = {
    enable = true;
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
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
  ];
}
