{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.sergt-pc = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.sergt-pc
      inputs.hjem.nixosModules.default
    ];
  };
  flake.nixosModules.sergt-pc =
    {
      pkgs,
      lib,
      ...
    }:
    let
      # Bulk data drives, all shown in the file manager via gvfs.
      dataDrive = label: {
        name = "/mnt/${label}";
        value = {
          inherit label;
          fsType = "ext4";
          options = [
            "defaults"
            "x-gvfs-show"
          ];
          noCheck = true;
        };
      };
    in
    {
      imports = [
        self.nixosModules.linux-base
        self.nixosModules.graphics-amd

        self.nixosModules.desktop
        self.nixosModules.theme
        self.nixosModules.no-rgb
        self.nixosModules.gaming
        self.nixosModules.vr
        self.nixosModules.programming
        self.nixosModules.music
        self.nixosModules.zapret
        self.nixosModules.virtualization
        self.nixosModules.vpn
      ];

      networking.hostName = "sergt-pc";

      preferences.login.autologin = true;

      ### DISPLAY ###
      # The only display is an external monitor, so brightness goes over DDC/CI
      # rather than a backlight class device. ddcutil drives it from userspace,
      # which avoids the kernel ddcci driver entirely: that one has to be bound
      # by hand to the DP AUX bus and only after the link is trained, so it
      # needed a timed udev rule that lost the race often enough to matter.
      #
      # The bus is stable across reboots; re-check with `ddcutil detect` if the
      # keys ever stop working. Note an `i2cget` probe of 0x37 false-negatives
      # on an AUX-backed bus, so don't use one to look for it.
      preferences.brightness = {
        backend = "ddcci";
        i2cBus = 6;
      };

      boot.kernelModules = [ "i2c-dev" ];

      ### DRIVES ###
      fileSystems = lib.listToAttrs (
        map dataDrive [
          "hard"
          "chonky"
          "fasty"
        ]
      );

      environment.systemPackages = [ pkgs.unstable.deadlock-mod-manager ];
    };
}
