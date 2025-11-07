{pkgs, ...}: {
  environment.systemPackages = with pkgs.unstable; [
    docker
    utm
    #compilers
    clang
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

  launchd.daemons.colima = {
    command = "${pkgs.colima}/bin/colima start --foreground";
    serviceConfig = {
      Label = "com.colima.default";
      RunAtLoad = true;
      KeepAlive = true;

      StandardOutPath = "/tmp/.colima.out.log";
      StandardErrorPath = "/tmp/.colima.err.log";
    };
  };
}
