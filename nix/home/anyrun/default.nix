{
  pkgs,
  inputs,
}: {
  imports = [inputs.anyrun.homeManagerModules.default];
  home.packages = [
    inputs.anyrun.packages.${pkgs.system}.anyrun
  ];
  programs.anyrun = {
    enable = true;
  };
}
