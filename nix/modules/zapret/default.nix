{pkgs, ...}: let
  quic_google = builtins.fetchurl {
    url = "https://github.com/bol-van/zapret/raw/refs/heads/master/files/fake/quic_initial_www_google_com.bin";
    sha256 = "02n5v8fya194ww3lffvjm2qgh1bh3m97l69q0nrnp5czfibrqn7l";
  };
  client_hello = builtins.fetchurl {
    url = "https://github.com/bol-van/zapret/raw/refs/heads/master/files/fake/tls_clienthello_www_google_com.bin";
    sha256 = "0p172hxcfsf5knap4wdimp8vqgsbhg6cnbbb88yam07v9kp2nv4k";
  };
  client_hello_max = builtins.fetchurl {
    url = "https://github.com/Flowseal/zapret-discord-youtube/raw/refs/heads/main/bin/tls_clienthello_max_ru.bin";
    sha256 = "0916jb7lkzssfay67ycbmq6j27dshycii5801dh2h08apq58gq2f";
  };
  stun = builtins.fetchurl {
    url = "https://github.com/Flowseal/zapret-discord-youtube/raw/refs/heads/main/bin/stun.bin";
    sha256 = "0hcnlmhb486bzsf1ghq2km9fxis89996cwnr1dnaa33q169ldmcw";
  };
  ipset_all = builtins.fetchurl {
    url = "https://github.com/Flowseal/zapret-discord-youtube/raw/9a1ce92593bd9af4e2e0b4af4d9db69c71e4af00/lists/ipset-all.txt.backup";
    sha256 = "0y33sq6gk9n12mgr28m1hwwzy1wjhwkdqgjmll4m3szpgf9cfkcv";
  };

  hostlist = builtins.toFile "zapret_whitelist" (builtins.concatStringsSep "\n" whitelist);
  whitelist = (import ./whitelist.nix {}).whitelist;
in {
  programs.throne = {
    enable = true;
    tunMode.enable = true;
    tunMode.setuid = true;
  };
  networking.nameservers = ["1.1.1.1" "8.8.8.8" "8.8.4.4"];
  services.zapret = {
    enable = true;
    package = pkgs.unstable.zapret;
    udpSupport = true;
    udpPorts = [
      "50000:50099"
      "19294:19344"
      "443"
      "1024:65535"
    ];
    httpSupport = true;
    params = [
      "--filter-tcp=443 --ip-id=zero --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls=${client_hello} --hostlist ${hostlist} --new"
      "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${quic_google} --hostlist ${hostlist} --new"
      "--filter-udp=19294-19344,50000-50099 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new"

      "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${quic_google} --ipset ${ipset_all} --new"
      "--filter-tcp=80,443,8443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls=${stun} --dpi-desync-fake-tls=${client_hello} --dpi-desync-fake-http=${client_hello_max} --ipset ${ipset_all} --new"
      "--filter-tcp=1024-65535 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-any-protocol=1 --dpi-desync-cutoff=n4 --dpi-desync-fooling=ts --dpi-desync-fake-tls=${stun} --dpi-desync-fake-tls=${client_hello} --dpi-desync-fake-http=${client_hello_max} --ipset ${ipset_all} --new"
      "--filter-udp=1024-65535 --dpi-desync=fake --dpi-desync-repeats=12 --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp=${quic_google} --dpi-desync-cutoff=n3 --ipset ${ipset_all} --new"

      # --filter-udp=444-6694,6706-65535 --ipset="%LISTS%ipset-amazon.txt" --dpi-desync-ttl=8 --dpi-desync-repeats=20 --dpi-desync-fooling=none --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp="%BIN%quic_initial_www_google_com.bin" --dpi-desync=fake --dpi-desync-cutoff=n10 --new ^
      # --filter-tcp=6695-6705 --dpi-desync=fake,split2 --dpi-desync-repeats=8 --dpi-desync-fooling=md5sig --dpi-desync-autottl=2 --dpi-desync-fake-tls="%BIN%tls_clienthello_www_google_com.bin"
    ];
  };
}
