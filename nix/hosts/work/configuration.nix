{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./kanata.nix
  ];
  environment.systemPackages = with pkgs; [
    gitMinimal
    neovim
    aerospace
    telegram-desktop
    rio
    betterdisplay

    docker
    utm
    #compilers
    clang
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

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  users.groups.docker.members = ["user"];

  system.primaryUser = "user";
  users.users.user = {
    name = "user";
    home = "/Users/user";
    shell = pkgs.zsh;
  };

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
