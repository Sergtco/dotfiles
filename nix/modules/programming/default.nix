{pkgs, ...}: {
  users.users.sergtco.extraGroups = ["docker"];
  virtualisation.docker = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    #compilers
    gcc
    clang
    unstable.python3
    unstable.uv
    unstable.go
    unstable.rustup
    unstable.zig

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
  ];

  documentation.dev.enable = true;
  documentation.man.generateCaches = true;
}
