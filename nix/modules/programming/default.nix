{pkgs, ...}: {
  users.users.sergtco.extraGroups = ["docker"];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  environment.systemPackages = with pkgs.unstable; [
    #compilers
    gcc
    clang
    python3
    uv
    go
    rustup
    zig

    #utils
    jq
    gnumake
    nixos-firewall-tool

    #manuals
    man-pages
    man-pages-posix
    tlrc

    # language utils
    ruff
    stylua
    alejandra
    gofumpt
    nodePackages.prettier
    clang-tools
    gdb
    delve
    typst
    tinymist
    typstyle
  ];

  documentation.dev.enable = true;
  documentation.man.generateCaches = true;
}
