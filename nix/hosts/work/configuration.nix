{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./kanata.nix
    ./dev.nix
  ];
  environment.systemPackages = with pkgs; [
    gitMinimal
    firefox
    neovim
    telegram-desktop
    betterdisplay
    rio
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  users.groups.docker.members = ["user"];

  system.primaryUser = "user";
  users.knownUsers = ["user"];
  users.users.user = {
    name = "user";
    home = "/Users/user";
    uid = 501;
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  environment.variables = {
    LANG = "en_US.UTF-8";
  };

  system.stateVersion = 6;
  nix.settings.experimental-features = "nix-command flakes";
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config = {
    allowUnfree = true;
  };

  nixpkgs.overlays = [
    (final: _: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final.stdenv.hostPlatform) system;
        inherit (final) config;
      };
    })
  ];
}
