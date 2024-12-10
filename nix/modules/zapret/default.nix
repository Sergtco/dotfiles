{pkgs, ...}: {
  disabledModules = ["services/networking/zapret.nix"]; # необходимо если версия nixpkgs новее 5a5c04d

  imports = [./zapret_service.nix];

  services.zapret = {
    enable = true;
    udpSupport = true;
    udpPorts = ["50000:50099"];
    params = [
      "--filter-tcp=443,80 --dpi-desync=split2 --dpi-desync-split-seqovl=9 --dpi-desync-split-pos=10 --wssize 1:6 --new"
      "--dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-repeats=6"
    ];
  };
}
