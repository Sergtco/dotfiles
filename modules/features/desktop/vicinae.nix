{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      vicinae = pkgs.unstable.vicinae;
      manifestName = "com.vicinae.vicinae.json";
      conf_text = ''
        {
        "name": "com.vicinae.vicinae",
          "description": "Vicinae native messaging host",
          "path": "${vicinae}/libexec/vicinae/vicinae-browser-link",
          "type": "stdio",
          "allowed_origins": [
            "chrome-extension://kcmipingpfbohfjckomimmahknoddnke/"
          ]
        }
      '';
      user = config.preferences.user.name;
    in
    {
      systemd.user.services.vicinae = {
        description = "Vicinae Launcher Daemon";
        documentation = [ "https://docs.vicinae.com" ];
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        path = ["/run/current-system/sw"];
        environment = {
          HTTP_PROXY = "http://127.0.0.1:10809";
          HTTPS_PROXY = "http://127.0.0.1:10809";
          USE_LAYER_SHELL = "1";
          NODE_USE_ENV_PROXY = "1";
        };
        serviceConfig = {
          Type = "simple";
          ExecStart = "${lib.getExe vicinae} server --replace";
          ExecReload = "/user/bin/env kill -HUP $MAINPID";
          Restart = "always";
          RestartSec = "60";
          KillMode = "process";
        };
      };
      hjem.users.${user}.files = {
        ".config/net.imput.helium/NativeMessagingHosts/com.vicinae.vicinae.json".text = conf_text;
        ".config/chromium/NativeMessagingHosts/com.vicinae.vicinae.json".text = conf_text;
      };
    };
}
