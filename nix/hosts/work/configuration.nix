{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./kanata.nix
    ./dev.nix
    ../../modules/fonts.nix
  ];
  environment.systemPackages = with pkgs; [
    gitMinimal
    firefox
    pkgs.nur.repos.forkprince.helium-nightly
    neovim
    telegram-desktop
    betterdisplay
    alacritty-graphics;
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
    inputs.nur.overlays.default
    (final: _: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final.stdenv.hostPlatform) system;
        inherit (final) config;
      };
    })
  ];
}
