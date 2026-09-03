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
          # old params
          # "--filter-tcp=443 --ip-id=zero --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls=${client_hello} --hostlist ${hostlist} --new"
          # "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${quic_google} --hostlist ${hostlist} --new"
          # "--filter-udp=19294-19344,50000-50099 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new"
          # "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${quic_google} --ipset ${ipset} --new"
          # "--filter-tcp=80,443,8443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls=${stun} --dpi-desync-fake-tls=${client_hello} --dpi-desync-fake-http=${client_hello_max} --ipset ${ipset} --new"

          # SIMPLE FAKE ALT from zapret-discord-youtube-1.9.9d
          "--filter-udp=443 --hostlist ${hostlist} --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${quic_google} --new"
          "--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-fake-discord=${quic_dbank} --dpi-desync-fake-stun=${quic_dbank} --dpi-desync-repeats=6 --new"
          "--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=2 --dpi-desync-fake-tls=${client_hello} --new"
          "--filter-tcp=443 --hostlist ${google_hostlist} --ip-id=zero --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=2 --dpi-desync-fake-tls=${client_hello} --new"
          "--filter-tcp=80,443 --hostlist ${hostlist} --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=2 --dpi-desync-fake-tls=${stun} --dpi-desync-fake-tls=${client_hello} --dpi-desync-fake-http=${client_hello_max} --new"
          "--filter-udp=443 --ipset ${ipset} --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${quic_google} --new"
          "--filter-tcp=80,443,8443 --ipset ${ipset} --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=2 --dpi-desync-fake-tls=${stun} --dpi-desync-fake-tls=${client_hello} --dpi-desync-fake-http=${client_hello_max} --new"
          "--filter-tcp=1024-65535 --ipset ${ipset} --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-any-protocol=1 --dpi-desync-cutoff=n3 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=2 --dpi-desync-fake-tls=${stun} --dpi-desync-fake-tls=${client_hello} --dpi-desync-fake-http=${client_hello_max} --dpi-desync-fake-unknown=${stun} --dpi-desync-fake-unknown=${client_hello} --new"
          "--filter-udp=1024-65535 --ipset ${ipset} --dpi-desync=fake --dpi-desync-repeats=10 --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp=${quic_dbank} --dpi-desync-cutoff=n2"
        ];
      };
    };
}
