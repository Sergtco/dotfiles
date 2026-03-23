{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.desktop = {
    pkgs,
    lib,
    config,
    ...
  }: let
    selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    manifestName = "com.vicinae.vicinae.json";
    conf_text = ''
      {
      "name": "com.vicinae.vicinae",
        "description": "Vicinae native messaging host",
        "path": "${selfpkgs.vicinae}/libexec/vicinae/vicinae-browser-link",
        "type": "stdio",
        "allowed_origins": [
          "chrome-extension://kcmipingpfbohfjckomimmahknoddnke/"
        ]
      }
    '';
  in {
    environment.etc."chromium/native-messaging-hosts/com.vicinae.vicinae.json".text = conf_text;
    environment.etc."net.imput.helium/native-messaging-hosts/com.vicinae.vicinae.json".text = conf_text;
  };
}
