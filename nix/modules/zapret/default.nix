{inputs, ...}: let
  quic_google = builtins.fetchurl {
    url = "https://github.com/bol-van/zapret/raw/refs/heads/master/files/fake/quic_initial_www_google_com.bin";
    sha256 = "02n5v8fya194ww3lffvjm2qgh1bh3m97l69q0nrnp5czfibrqn7l";
  };
  tls_google = builtins.fetchurl {
    url = "https://github.com/bol-van/zapret/raw/refs/heads/master/files/fake/tls_clienthello_www_google_com.bin";
    sha256 = "1pichrzkjz0kri0frdc3kcv7g54y62xym01z70hgfs912n08g4z5";
  };
in {
  disabledModules = ["services/networking/zapret.nix"];

  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/networking/zapret.nix"
  ];

  services.zapret = {
    enable = true;
    udpSupport = true;
    udpPorts = ["50000:50099"];
    httpSupport = false;
    params = [
      "--filter-tcp=443 --dpi-desync=fake --dpi-desync-autottl=2 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=${tls_google}"
      "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${quic_google} --new"
      " --filter-udp=50000-50099 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n2 --dpi-desync-repeats=6 --new"
    ];
    whitelist = [
      "ntc.party"
      "cker.cc"
      "googleapis.com"
      "googleusercontent.com"
      "googlevideo.com"
      "gstatic.com"
      "nhacmp3youtube.com"
      "www.youtube.com"
      "youtu.be"
      "youtube.com"
      "youtubei.googleapis.com"
      "yt4.ggpht.com"
      "ytimg.com"
      "ytimg.l.google.com"
      "x.com"
      "twimg.com"
      "t.co"
      "twitter.com"
      "rutor.info"
      "rutracker.org"
      "instagram.com"
      "cdninstagram.com"
      "ig.me"
      "donmai.us"
      "facebook.com"
      "fbcdn.net"
      "facebook.net"
      "fbsbx.com"
      "fbpigeon.com"
      "fb.com"
      "fb.gg"
      "discord.com"
      "gateway.discord.gg"
      "cdn.discordapp.com"
      "discordapp.net"
      "discordapp.com"
      "discord.gg"
      "media.discordapp.net"
      "images-ext-1.discordapp.net"
      "www.discord.com"
      "www.discord.app"
      "discord.app"
      "*.discord.com"
      "*.discord.gg"
      "*.discordapp.com"
      "*.discordapp.net"
      "discord.media"
      "*.discord.media"
      "discordcdn.com"
      "discord.dev"
      "discord.new"
      "discord.gift"
      "discordstatus.com"
      "dis.gd"
      "discord.com"
    ];
  };
}
