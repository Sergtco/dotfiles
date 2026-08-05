_: {
  flake.nixosModules.music =
    { pkgs, config, ... }:
    let
      user = config.preferences.user.name;
    in
    {
      users.groups = {
        realtime = { };
        audio = { };
      };
      users.users.${user}.extraGroups = [
        "realtime"
        "audio"
      ];
      services.pipewire = {
        jack.enable = true;
      };
      environment.systemPackages = with pkgs; [
        guitarix
        gxplugins-lv2
        crosspipe
      ];
    };
}
