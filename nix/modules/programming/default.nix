{ pkgs, ... }:
{
  users.users.sergtco.extraGroups = [ "docker" ];
  programs.nix-ld = {
    enable = true;
  };
  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    gcc
    clang
    unstable.python3
    unstable.go
    unstable.cargo
    unstable.rustup
    unstable.rustc
    unstable.zig
  ];
}
