{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.nix = {pkgs, ...}: {
    imports = [
      inputs.nix-index-database.nixosModules.default
    ];
    nix.settings = {
      trusted-users = [
        "sergtco"
      ];
      builders-use-substitutes = true;
      substituters = [
        "https://cache.nixos.org/"
        "https://vicinae.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    nix.package = pkgs.lixPackageSets.stable.lix;

    nix.optimise = {
      automatic = true;
      dates = "weekly";
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
    };

    programs = {
      nix-index.enable = true;
      nix-index-database.comma.enable = true;
    };
  };
}
