{pkgs, ...}: {
  environment.systemPackages = with pkgs.unstable; [
    gitMinimal
    docker
    colima

    clang
    darwin.libresolv

    #compilers
    python3
    uv
    go

    #utils
    jq
    gnumake

    #manuals
    man-pages
    man-pages-posix
    tlrc

    # language utils
    stylua
    alejandra
    gofumpt
    delve
  ];
  launchd.agents.colima = {
    command = "${pkgs.colima}/bin/colima start --foreground";
    serviceConfig = {
      Label = "com.colima.default";
      RunAtLoad = true;
      KeepAlive = true;

      # not sure where to put these paths and not reference a hard-coded `$HOME`; `/var/log`?
      StandardOutPath = "/tmp/colima.out.log";
      StandardErrorPath = "/tmp/colima.err.log";

      # not using launchd.agents.<name>.path because colima needs the system ones as well
      EnvironmentVariables = {
        PATH = "${pkgs.colima}/bin:${pkgs.docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };
}
