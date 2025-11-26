{pkgs, ...}: {
  environment.systemPackages = with pkgs.unstable; [
    gitMinimal
    docker
    utm
    colima

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
}
