{pkgs, ...}
  :
{
  users.users.sergtco.extraGroups = [ "realtime" "audio" ];
  environment.systemPackages = with pkgs; [
    guitarix
    gxplugins-lv2
  ];
}
