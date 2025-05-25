{...}: {
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["sergtco"];
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
  };
  virtualisation.spiceUSBRedirection.enable = true;
}
