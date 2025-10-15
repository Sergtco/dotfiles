{pkgs, ...}: {
  launchd = {
    daemons = {
      kanata = {
        command = "${pkgs.kanata}/bin/kanata -c ${./home-row.kbd}";
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/kanata.out.log";
          StandardErrorPath = "/tmp/kanata.err.log";
        };
      };
    };
  };
}
