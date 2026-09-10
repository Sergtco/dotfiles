_: {
  flake.nixosModules.virtualization =
    { config, lib, pkgs, ... }:
    let
      user = config.preferences.user.name;
    in
    {
      programs.virt-manager.enable = true;

      users.users.${user}.extraGroups = [
        "libvirtd"
      ];
      virtualisation.libvirtd = {
        enable = true;
        onBoot = "ignore";
      };
      virtualisation.spiceUSBRedirection.enable = true;
    };
}
