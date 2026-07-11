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

      user = config.preferences.user.name;
    in
    {
      environment.systemPackages = with pkgs; [
        unstable.sidequest
        unstable.wayvr
        unstable.ydotool
        unstable.looking-glass-client
        android-tools
      ];

      programs.alvr = {
        enable = true;
        package = pkgs.unstable.alvr;
        openFirewall = true;
      };

      services.wivrn = {
        enable = true;
        package = pkgs.unstable.wivrn;
        openFirewall = true;
        autoStart = true;
      };

      hjem.users.${user}.xdg = {
        config.files."openxr/1/active_runtime.json".source =
          "${pkgs.unstable.wivrn}/share/openxr/1/openxr_wivrn.json";
      };

    };
}
