{pkgs, ...}: {
  launchd.user.agents.kanata = {
    command = "sudo ${pkgs.unstable.kanata}/bin/kanata -c ${./home-row.kbd}";
    serviceConfig = {
      ProcessType = "Interactive";
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/tmp/kanata.out.log";
      StandardErrorPath = "/tmp/kanata.err.log";
    };
  };
  security.sudo.extraConfig = ''
    %admin ALL=(root) NOPASSWD: ${pkgs.unstable.kanata}/bin/kanata -c ${./home-row.kbd}
  '';
}
