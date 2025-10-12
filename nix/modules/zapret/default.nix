{pkgs, ...}: let
  quic_google = builtins.fetchurl {
    url = "https://github.com/bol-van/zapret/raw/refs/heads/master/files/fake/quic_initial_www_google_com.bin";
    sha256 = "02n5v8fya194ww3lffvjm2qgh1bh3m97l69q0nrnp5czfibrqn7l";
  };
  client_hello = builtins.fetchurl {
    url = "https://github.com/bol-van/zapret/raw/refs/heads/master/files/fake/tls_clienthello_www_google_com.bin";
    sha256 = "0p172hxcfsf5knap4wdimp8vqgsbhg6cnbbb88yam07v9kp2nv4k";
  };
  hostlist = builtins.toFile "zapret_whitelist" (builtins.concatStringsSep "\n" whitelist);
  whitelist = (import ./whitelist.nix {}).whitelist;
in {
  programs.nekoray = {
    enable = true;
    package = pkgs.unstable.nekoray;
    tunMode.enable = true;
    tunMode.setuid = true;
  };

  services.zapret = {
    enable = true;
    package = pkgs.unstable.zapret;
    udpSupport = true;
    udpPorts = [
      "50000:50099"
      "19294:19344"
    ];
    httpSupport = false;
    params = [
      "--filter-tcp=443 --dpi-desync=fake,multidisorder --dpi-desync-split-pos=method+2,midsld,5 --dpi-desync-ttl=1 --dpi-desync-fooling=md5sig,badsum,badseq --dpi-desync-repeats=15 --dpi-desync-fake-tls=${client_hello} --hostlist ${hostlist} --new"
      "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${quic_google} --hostlist ${hostlist} --new"
      "--filter-udp=19294-19344,50000-50099 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new"
    ];
  };
}
