{pkgs, ...}: {
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
