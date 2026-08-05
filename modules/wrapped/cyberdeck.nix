{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.cyberdeck = pkgs.callPackage (
        {
          lib,
          appimageTools,
          fetchurl,
        }:
        let
          version = "1.6.6";
          pname = "vr-cyberdeck";
          src = fetchurl {
            url = "https://github.com/DeliciousMeatPop/VRCD/releases/download/v${version}/vr-cyberdeck-${version}-x86_64.AppImage";
            hash = "sha256-Hz2E0GULnPA0b/Js4BMojkMuUv0f+mLUdG81DxBfRaM=";
          };
        in
        appimageTools.wrapType2 {
          inherit pname version src;
          meta = {
            description = "VR CyberDeck";
            homepage = "https://github.com/DeliciousMeatPop/VRCD";
            license = lib.licenses.unfree;
            sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
            platforms = [ "x86_64-linux" ];
          };
        }
      ) { };
    };
}
