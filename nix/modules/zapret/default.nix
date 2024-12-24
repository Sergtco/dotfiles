{inputs, ...}: {
  disabledModules = ["services/networking/zapret.nix"];

  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/networking/zapret.nix"
  ];

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
