{ inputs, ... }:
{
  # The partition table, applied from the installer before `nixos-install`:
  #
  #   sudo nix run 'github:nix-community/disko/latest#disko' -- \
  #     --mode destroy,format,mount --flake /path/to/dotfiles#steamdeck
  #
  # This wipes the drive, so the Steam Deck recovery image is the way back.
  # The same definitions generate `fileSystems`, which is why
  # hardware-configuration.nix has none.
  flake.nixosModules.steamdeck = _: {
    imports = [ inputs.disko.nixosModules.disko ];

    disko.devices.disk.main = {
      # The 512G and 1T models are nvme0n1; the 64G LCD model's eMMC shows up
      # as mmcblk0 instead.
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          # Bigger than the 512M an installer would suggest: every generation
          # kept here is a Valve kernel plus its initrd. Sized against the
          # `boot.loader.systemd-boot.configurationLimit` in configuration.nix.
          ESP = {
            priority = 1;
            name = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          # No swap partition: `jovian.steamos.enableZram` sets up zram the way
          # SteamOS does.
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
