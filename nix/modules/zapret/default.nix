{
  lib,
  ...
}: let
  discord_ips = builtins.toPath (builtins.fetchurl {
    url = "https://raw.githubusercontent.com/iamkuper/amnezia-discord-config/refs/heads/main/configs/all.ips.txt";
    sha256 = "1q7l5avf3bqxpsv7dd43mpwj13gc80jw7vc3a5jbzlmbpws1xzjr";
  });
in {
  disabledModules = ["services/networking/zapret.nix"];

  imports = [
    ./zapret_service.nix
  ];

  services.zapret = {
    enable = true;
    udpSupport = true;
    udpPorts = ["50000:50099"];
    httpSupport = false;
    params = [
      "--filter-tcp=443 --dpi-desync=split2 --dpi-desync-split-seqovl=9 --dpi-desync-split-pos=10 --wssize 1:6 --new"
      "--dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-repeats=6"
    ];
    whitelist = [
      "googlevideo.com"
      "youtubei.googleapis.com"
      "i.ytimg.com"
      "yt3.ggpht.com"
    ];
    iplist = lib.strings.splitString "\n" (builtins.readFile discord_ips);
  };
}
