{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.zapret =
    { pkgs, ... }:
    let
      quic_google = ./quic_initial_www_google_com.bin;
      quic_dbank = ./quic_initial_dbankcloud_ru.bin;
      client_hello = ./tls_clienthello_www_google_com.bin;
      client_hello_max = ./tls_clienthello_max_ru.bin;
      stun = ./stun.bin;

      ipset_all = builtins.readFile ./ipset-all.txt;
      google_hostlist = builtins.toFile "zapret_google" (builtins.readFile ./list-google.txt);

      hostlist = builtins.toFile "zapret_whitelist" (builtins.concatStringsSep "\n" self.whitelist);
      ipset = builtins.toFile "ipset" (
        builtins.concatStringsSep "\n" ([
          ipset_all

        ]
        ++ self.ipset)
      );

    in
    {
      services.zapret = {
        enable = true;
        package = pkgs.unstable.zapret;
        udpSupport = true;
        udpPorts = [
          "50000:50100"
          "19294:19344"
          "443"
          "1024:65535"
        ];
        httpSupport = true;
        params = [
          "--filter-l7=quic --hostlist ${hostlist} --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=${quic_google} --new"
          "--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun,unknown --dpi-desync=fake --dpi-desync-any-protocol=1 --dpi-desync-fake-discord=${quic_google} --dpi-desync-fake-discord=${quic_dbank} --dpi-desync-fake-stun=${quic_dbank} --dpi-desync-fake-unknown-udp=${quic_google} --dpi-desync-fake-unknown-udp=${quic_dbank} --dpi-desync-repeats=4 --dpi-desync-cutoff=n4 --new"
          "--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern=${client_hello} --dpi-desync-fake-tls=${client_hello} --new"
          "--filter-tcp=443 --hostlist ${google_hostlist} --ip-id=zero --dpi-desync=hostfakesplit --dpi-desync-fooling=ts --dpi-desync-hostfakesplit-mod=host=www.google.com --new"
          "--filter-tcp=80,443 --hostlist ${hostlist} --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=480 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=4 --dpi-desync-split-seqovl-pattern=${stun} --dpi-desync-fake-tls=${client_hello_max} --dpi-desync-fake-http=${client_hello_max} --new"
          "--filter-udp=443 --ipset ${ipset} --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=${quic_google} --new"
          "--filter-tcp=80,443,8443 --ipset ${ipset} --hostlist-exclude-domains=fonts.googleapis.com --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=480 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=4 --dpi-desync-split-seqovl-pattern=${stun} --dpi-desync-fake-tls=${client_hello_max} --dpi-desync-fake-http=${client_hello_max} --new"
          "--filter-tcp=1024-65535 --ipset ${ipset} --dpi-desync=fake,multisplit --dpi-desync-any-protocol=1 --dpi-desync-cutoff=n4 --dpi-desync-split-seqovl=664 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern=${client_hello_max} --dpi-desync-fake-tls=${stun} --dpi-desync-fake-tls=${client_hello_max} --dpi-desync-fake-http=${client_hello_max} --new"
          "--filter-udp=1024-65535 --ipset ${ipset} --dpi-desync=fake --dpi-desync-repeats=5 --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp=${quic_google} --dpi-desync-fake-unknown-udp=${quic_dbank} --dpi-desync-cutoff=n4"
        ];
      };
    };
}
