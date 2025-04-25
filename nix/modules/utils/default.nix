{pkgs, ...}: {
  programs.nh = {
    enable = true;
    flake = "/home/sergtco/dotfiles/nix";
  };
  environment.defaultPackages = with pkgs; [
    file
    usbutils
    imagemagick
    progress
  ];
}
