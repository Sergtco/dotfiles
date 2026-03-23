{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: let
    ini = pkgs.formats.ini {};
    settings = {
      main = {
        default-timeout = 5;
        max-timeout = 10;
        selection-helper = "vicinae dmenu";
        layer = "overlay";
        title-color = self.themeNoHash.base05 + "FF";
        summary-color = self.themeNoHash.base05 + "FF";
        body-color = self.themeNoHash.base05 + "FF";
        progress-color = self.themeNoHash.base02 + "FF";
        background = self.themeNoHash.base00 + "FF";
      };
      low.border-color = self.themeNoHash.base03 + "FF";
      normal.border-color = self.themeNoHash.base0D + "FF";
      critical.border-color = self.themeNoHash.base08 + "FF";
    };
  in {
    packages.fnott = inputs.wrapper-modules.lib.wrapPackage ({...}: {
      inherit pkgs;
      package = pkgs.fnott;
      flags = {
        "-c" = ini.generate "fnott.ini" settings;
      };
    });
  };
}
