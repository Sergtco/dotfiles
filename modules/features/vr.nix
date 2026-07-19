{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.vr =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
      user = config.preferences.user.name;
    in
    {
      environment.systemPackages = with pkgs; [
        unstable.sidequest
        unstable.wayvr
        unstable.ydotool
        unstable.looking-glass-client
        android-tools
        selfpkgs.cyberdeck
      ];

      users.users.${user}.extraGroups = [ "adbusers" ];

      services.wivrn = {
        enable = true;
        package = pkgs.unstable.wivrn;
        openFirewall = true;
        autoStart = true;
        config = {
          enable = true;
          json = {
            encoder = {
              encoder = "vaapi";
              codec = "h264";
            };
          };
        };
      };

      hjem.users.${user}.xdg = {
        config.files."openxr/1/active_runtime.json".source =
          "${pkgs.unstable.wivrn}/share/openxr/1/openxr_wivrn.json";
        config.files."openvr/openvrpaths.vrpath".text =
          let
            steam = "/home/${user}/Steam";
          in
          builtins.toJSON {
            version = 1;
            jsonid = "vrpathreg";

            external_drivers = null;
            config = [ "${steam}/config" ];

            log = [ "${steam}/logs" ];

            runtime = [
              "${pkgs.unstable.xrizer}/lib/xrizer"
            ];
          };
      };

    };
}
