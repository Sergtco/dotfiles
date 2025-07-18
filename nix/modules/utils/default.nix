{pkgs, ...}: {
  programs.nh = {
    enable = true;
    flake = "/home/sergtco/dotfiles/nix";
  };

  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  environment.defaultPackages = with pkgs; [
    file
    usbutils
    imagemagick
    progress
  ];
}
