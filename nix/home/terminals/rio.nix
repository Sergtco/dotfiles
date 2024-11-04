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
  programs.rio = {
    enable = true;
    settings = {
      theme = "kanagawa"
    };
  };

  xdg.configFile = {
    "rio/themes/kanagawa.toml".source = ./rio-kanagawa.toml;
  };
}
