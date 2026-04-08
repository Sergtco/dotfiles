{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.ai = {pkgs, ...}: {
    services.ollama = {
      enable = true;
      package = pkgs.unstable.ollama-rocm;
      acceleration = "rocm";
      rocmOverrideGfx = "10.3.0";
    };
  };
}
