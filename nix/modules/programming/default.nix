{pkgs, ...}: {
  users.users.sergtco.extraGroups = ["docker"];
  virtualisation.docker.enable = true;
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
  ];
  documentation.man.generateCaches = true;
}
