{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, inputs', ...}: {
    packages.helium = inputs.wrapper-modules.lib.wrapPackage ({...}: {
      inherit pkgs;
      package = inputs'.nur.legacyPackages.repos.forkprince.helium-nightly;
      flags = {
        "--disable-gpu-vsync" = true;
        "--disable-frame-rate-limit" = true;
      };
      flagSeparator = "=";
    });
  };
}
