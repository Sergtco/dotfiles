{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.ai = {pkgs, ...}: {
    services.ollama = {
      enable = true;
      acceleration = "rocm";
      rocmOverrideGfx = "10.3.0";
    };
  };
}
