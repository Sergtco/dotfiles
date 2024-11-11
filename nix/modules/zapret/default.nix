{ pkgs, ... }:
{
  imports = [ ./zapret_service.nix ];

  services.zapret = {
    enable = true;
    package = pkgs.unstable.zapret;

    params = [
      "--dpi-desync=fake,split2 --dpi-desync-ttl=5 --domcase --dpi-desync-fooling=md5sig"
      "--dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-repeats=6"
    ];
  };
  
  networking = {
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
  };

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      require_dnssec = true;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };
    };
  };
}
