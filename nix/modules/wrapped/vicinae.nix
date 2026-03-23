{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.vicinae = inputs.wrapper-modules.lib.wrapPackage ({...}: {
      inherit pkgs;
      package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
      env = {
        HTTP_PROXY = "http://127.0.0.1:10809";
        HTTPS_PROXY = "http://127.0.0.1:10809";
        USE_LAYER_SHELL = "1";
        NODE_USE_ENV_PROXY = "1";
      };
    });
  };
}
