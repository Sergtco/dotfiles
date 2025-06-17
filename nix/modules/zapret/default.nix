{...}: let
  quic_google = builtins.fetchurl {
    url = "https://github.com/bol-van/zapret/raw/refs/heads/master/files/fake/quic_initial_www_google_com.bin";
    sha256 = "02n5v8fya194ww3lffvjm2qgh1bh3m97l69q0nrnp5czfibrqn7l";
  };
in {
  programs.nekoray = {
    enable = true;
    tunMode.enable = true;
  };
  services.zapret = {
    enable = true;
    udpSupport = true;
    udpPorts = ["50000:50099"];
    httpSupport = true;
    params = [
      "--filter-tcp=443,80 --dpi-desync=split2 --dpi-desync-split-seqovl=9 --dpi-desync-split-pos=10 --wssize 1:6 --new"
      "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${quic_google} --new"
      "--filter-udp=50000-50099 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n2 --dpi-desync-repeats=6 --new"
    ];
    whitelist = [
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
      "discord.app"
      "discord.media"
      "discordcdn.com"
      "discord.dev"
      "discord.new"
      "discord.gift"
      "discordstatus.com"
      "dis.gd"
      "discord.co"
      "discord-attachments-uploads-prd.storage.googleapis.com"
      "cloudflare-ech.com"
      "cloudflare.com"
      "cloudflare.steamstatic.com"
    ];
  };
}
