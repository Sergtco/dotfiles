{
  self,
  inputs,
  ...
}: {
  flake.darwinConfigurations."MacBook-Pro-user" = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      self.modules.darwin."MacBook-Pro-user"
    ];
  };
  flake.darwinModules."MacBook-Pro-user" = {pkgs, ...}: let
    selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    imports = [
      self.darwinModules.kanata
      self.darwinModules.fonts
      self.darwinModules.dev
    ];
    environment.systemPackages = with pkgs; [
      telegram-desktop
      betterdisplay
      selfpkgs.shell
      selfpkgs.helium
      selfpkgs.git
      selfpkgs.neovim
    ];

    users.groups.docker.members = ["user"];

    system.primaryUser = "user";
    users.knownUsers = ["user"];
    users.users.user = {
      name = "user";
      home = "/Users/user";
      uid = 501;
      shell = selfpkgs.shell;
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
  };
}
