{
  config,
  pkgs,
  inputs,
  ...
}:
let
  unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
  };
in
{
  programs.steam = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
  lutris
  wine
  ];
}
