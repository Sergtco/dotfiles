{pkgs, ...}: {
  users.groups = {
    realtime = {};
    audio = {};
  };
  users.users.sergtco.extraGroups = [
    "realtime"
    "audio"
  ];
  services.pipewire = {
    jack.enable = true;
  };
  environment.systemPackages = with pkgs; [
    guitarix
    gxplugins-lv2
    helvum
  ];
}
