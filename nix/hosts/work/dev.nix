{pkgs, ...}: {
  environment.systemPackages = with pkgs.unstable; [
    docker
    utm
    go-swag
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
