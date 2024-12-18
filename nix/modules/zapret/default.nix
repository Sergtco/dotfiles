{
  pkgs,
  lib,
  ...
}: let
  # whitelist.path = builtins.fetchurl {
  #   url = "https://antizapret.prostovpn.org/domains-export.txt";
  #   sha256 = "sha256:16vj16ih82d3q9idp0qz69ia63qvy30zgbgi5aaalkw2vd1ihqwa";
  # };
  # whitelist.contents = builtins.readFile whitelist.path;
in {
  disabledModules = ["services/networking/zapret.nix"]; # необходимо если версия nixpkgs новее 5a5c04d

  imports = [./zapret_service.nix];

  services.zapret = {
    enable = true;
    udpSupport = true;
    # whitelist = lib.strings.splitString "\n" whitelist.contents;
    udpPorts = ["50000:50099"];
    params = [
      "--filter-tcp=443,80 --dpi-desync=split2 --dpi-desync-split-seqovl=9 --dpi-desync-split-pos=10 --wssize 1:6 --new"
      "--dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-repeats=6"
    ];
  };
}
