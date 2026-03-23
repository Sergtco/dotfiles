{
  self,
  inputs,
  ...
}: let
  fonts = {pkgs, ...}: {
    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.zed-mono
      nerd-fonts.jetbrains-mono
      corefonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
    ];
  };
in {
  flake.nixosModules.fonts = fonts;
  flake.darwinModules.fonts = fonts;
}
