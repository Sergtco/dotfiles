{pkgs, ...}: let
  quic_google = builtins.fetchurl {
    url = "https://github.com/bol-van/zapret/raw/refs/heads/master/files/fake/quic_initial_www_google_com.bin";
    sha256 = "02n5v8fya194ww3lffvjm2qgh1bh3m97l69q0nrnp5czfibrqn7l";
  };
  client_hello = builtins.fetchurl {
    url = "https://github.com/bol-van/zapret/raw/refs/heads/master/files/fake/tls_clienthello_www_google_com.bin";
    sha256 = "0p172hxcfsf5knap4wdimp8vqgsbhg6cnbbb88yam07v9kp2nv4k";
  };
  whitelist = [
    "dis.gd"
    "discord-attachments-uploads-prd.storage.googleapis.com"
    "discord.app"
    "discord.co"
    "discord.com"
    "discord.design"
    "discord.dev"
    "discord.gift"
    "discord.gifts"
    "discord.gg"
    "discord.media"
    "discord.new"
    "discord.store"
    "discord.status"
    "discord-activities.com"
    "discordactivities.com"
    "discordapp.com"
    "discordapp.net"
    "discordcdn.com"
    "discordmerch.com"
    "discordpartygames.com"
    "discordsays.com"
    "discordsez.com"
    "stable.dl2.discordapp.net"
    "yt3.ggpht.com"
    "yt4.ggpht.com"
    "yt3.googleusercontent.com"
    "googlevideo.com"
    "jnn-pa.googleapis.com"
    "wide-youtube.l.google.com"
    "youtube-nocookie.com"
    "youtube-ui.l.google.com"
    "youtube.com"
    "youtubeembeddedplayer.googleapis.com"
    "youtubekids.com"
    "youtubei.googleapis.com"
    "youtu.be"
    "yt-video-upload.l.google.com"
    "ytimg.com"
    "ytimg.l.google.com"
    "rutracker.org"
  ];
  hostlist = builtins.toFile "zapret_whitelist" (builtins.concatStringsSep "\n" whitelist);
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
    udpPorts = ["50000:50099"];
    httpSupport = false;
    params = [
      "--filter-tcp=443 --dpi-desync=fake,multidisorder --dpi-desync-split-pos=method+2,midsld,5 --dpi-desync-ttl=1 --dpi-desync-fooling=md5sig,badsum,badseq --dpi-desync-repeats=15 --dpi-desync-fake-tls=${client_hello} --hostlist ${hostlist} --new"
      "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${quic_google} --hostlist ${hostlist} --new"
      "--filter-udp=50000-50099 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n2 --dpi-desync-repeats=6 --hostlist ${hostlist} --new"
    ];
  };
}
