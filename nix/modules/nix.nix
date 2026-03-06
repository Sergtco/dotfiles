{...}: {
  nix.settings = {
    trusted-users = [
      "sergtco"
    ];
    builders-use-substitutes = true;
    substituters = [
      "https://cache.nixos.org/"
      "https://install.determinate.systems"
      "https://vicinae.cachix.org"
    ];
    trusted-public-keys = [
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nix.optimise = {
    automatic = true;
    dates = "weekly";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };
}
