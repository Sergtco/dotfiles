{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.helium = inputs.wrapper-modules.lib.wrapPackage ({...}: {
      inherit pkgs;
      package = inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.forkprince.helium-nightly;
      flags = {
        "--disable-gpu-vsync" = true;
        "--disable-frame-rate-limit" = true;
      };
      flagSeparator = "=";
    });
  };
}
