{pkgs, ...}: {
  launchd.daemons.kanata = {
    command = "${pkgs.unstable.kanata}/bin/kanata -c ${./home-row.kbd}";
    serviceConfig = {
      ProcessType = "Interactive";
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/tmp/kanata.out.log";
      StandardErrorPath = "/tmp/kanata.err.log";
    };
  };
}
