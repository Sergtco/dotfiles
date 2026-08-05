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
      config,
      lib,
      ...
    }:
    let
      user = config.preferences.user.name;

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

      # i2c: needed to talk DDC/CI to the monitors, see below.
      users.users.${user}.extraGroups = [ "i2c" ];

      ### DISPLAY ###
      # Control monitor brightness over DDC/CI, which needs the ddcci kernel
      # driver bound to whichever i2c bus the monitor actually answers on.
      boot = {
        extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
        kernelModules = [
          "i2c-dev"
          "ddcci"
          "ddcci-backlight"
        ];
      };

      services.udev.extraRules = ''
        SUBSYSTEM=="i2c-dev", ACTION=="add",\
          ATTR{name}=="AMDGPU DM*",\
          TAG+="ddcci",\
          TAG+="systemd",\
          ENV{SYSTEMD_WANTS}+="ddcci@$kernel.service"
      '';
      systemd.services."ddcci@" = {
        scriptArgs = "%i";
        script = ''
          bus=''${1##*-}          # "i2c-6" -> "6"
          echo "Trying to attach ddcci to bus $bus"
          if ${pkgs.i2c-tools}/bin/i2cget -y "$bus" 0x37 >/dev/null 2>&1; then
            echo ddcci 0x37 > "/sys/bus/i2c/devices/i2c-$bus/new_device"
          else
            echo "No DDC/CI device answering on bus $bus"
          fi
        '';
        serviceConfig.Type = "oneshot";
      };

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
