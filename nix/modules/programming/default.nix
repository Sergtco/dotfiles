{pkgs, ...}: {
  users.users.sergtco.extraGroups = ["docker"];
  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    #compilers 
    gcc
    clang
    unstable.python3
    unstable.go
    unstable.cargo
    unstable.rustc
    unstable.zig

    #utils
    jq
  ];
}
