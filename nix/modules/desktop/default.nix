{pkgs, ...}: {
  services = {
    tumbler.enable = true;
    blueman.enable = true;

    printing.enable = true;
    printing.drivers = with pkgs; [
      canon-cups-ufr2
    ];
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  ### Enable thunar fm
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  environment.systemPackages = with pkgs; [
    gnome-disk-utility
    xarchiver
    rar
    gimp3
  ];
}
