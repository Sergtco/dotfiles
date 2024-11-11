{ pkgs, ... }:
{
  imports = [ ./zapret_service.nix ];

  services.zapret = {
    enable = true;
    package = pkgs.unstable.zapret;

    params = [
      "--dpi-desync=fake,split2 --dpi-desync-ttl=5 --domcase --dpi-desync-fooling=md5sig"
      "--dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-repeats=6"
    ];
  };
  
}
