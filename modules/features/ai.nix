{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.ai = {pkgs, ...}: {
    services.ollama = {
      enable = true;
      package = pkgs.unstable.ollama-rocm;
      rocmOverrideGfx = "10.3.0";
    };
  };
}
