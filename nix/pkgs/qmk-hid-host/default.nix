let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs {
    config = { };
    overlays = [ ];
  };
in
{
  qmk-hid-host = pkgs.callPackage ./qmk-hid-host.nix { };
}
