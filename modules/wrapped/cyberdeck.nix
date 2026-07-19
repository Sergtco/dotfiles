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
          version = "1.4.7";
          pname = "vr-cyberdeck";
          src = fetchurl {
            url = "https://github.com/KaladinDMP/VR-CyberDeck/releases/download/v${version}/vr-cyberdeck-${version}-x86_64.AppImage";
            hash = "sha256-5mC8qsg7yBqTKocNaQEgrbSCx2ZuwnqcfrG5vfEQDDY=";
          };
        in
        appimageTools.wrapType2 {
          inherit pname version src;
          meta = {
            description = "VR CyberDeck";
            homepage = "https://github.com/KaladinDMP/VR-CyberDeck";
            license = lib.licenses.unfree;
            sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
            platforms = [ "x86_64-linux" ];
          };
        }
      ) { };
    };
}
