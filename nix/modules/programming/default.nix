{pkgs, ...}: {
  users.users.sergtco.extraGroups = ["docker"];
  virtualisation.docker = {
    enable = true;
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
    graphviz
    nixos-firewall-tool

    #manuals
    man-pages
    man-pages-posix
    tlrc

    # language utils
    black
    stylua
    alejandra
    gofumpt
    golangci-lint
    nodePackages.prettier
    clang-tools
    python312Packages.sqlfmt
    gdb
    delve
    typst
    tinymist
    typstyle
  ];

  documentation.dev.enable = true;
  documentation.man.generateCaches = true;
}
