{pkgs, ...}: {
  ### Enable thunar fm
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.tumbler.enable = true;
  services.blueman.enable = true;
  environment.systemPackages = with pkgs; [
    gnome-disk-utility
    xarchiver
    rar
    unrar
  ];
}
