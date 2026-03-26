{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.sergt-pc = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.sergt-pc
      inputs.hjem.nixosModules.default
    ];
  };
  flake.nixosModules.sergt-pc = {
    pkgs,
    config,
    ...
  }: let
    selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    user = config.preferences.user.name;
  in {
    hjem.users.${user}.directory = "/home/${user}";
    imports = [
      self.nixosModules.base
      self.nixosModules.gaming
      self.nixosModules.theme
      self.nixosModules.no-rgb
      self.nixosModules.programming
      self.nixosModules.music
      self.nixosModules.zapret
      self.nixosModules.virtualization
      self.nixosModules.desktop
      self.nixosModules.vpn
      self.nixosModules.ai
      self.nixosModules.fonts
      self.nixosModules.nix
    ];

    ### BOOTLOADER ###
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          efiSupport = true;
          device = "nodev";
          timeoutStyle = "hidden";
        };
      };
    };

    ### KERNEL ###
    boot = {
      extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
      initrd.kernelModules = ["amdgpu"];
      kernelModules = ["ddcci_backlight"];
    };

    services.udev.packages = with pkgs; [via];

    ### DISPLAY ###
    services.udev.extraRules = let
      bash = "${pkgs.bash}/bin/bash";
      ddcciDev = "AMDGPU DM aux hw bus 1";
      ddcciNode = "/sys/bus/i2c/devices/i2c-7/new_device";
    in ''
      SUBSYSTEM=="i2c", ACTION=="add", ATTR{name}=="${ddcciDev}", RUN+="${bash} -c 'echo ddcci 0x37 > ${ddcciNode}'"
    '';

    ### DRIVES ###
    services.udisks2.enable = true;
    services.gvfs.enable = true;
    fileSystems."/mnt/hard" = {
      label = "hard";
      fsType = "ext4";
      options = ["defaults" "x-gvfs-show"];
      noCheck = true;
    };

    fileSystems."/mnt/chonky" = {
      label = "chonky";
      fsType = "ext4";
      options = ["defaults" "x-gvfs-show"];
      noCheck = true;
    };

    fileSystems."/mnt/fasty" = {
      label = "fasty";
      fsType = "ext4";
      options = ["defaults" "x-gvfs-show"];
      noCheck = true;
    };

    ### NETWORKING ###
    networking.hostName = "sergt-pc";
    networking.networkmanager.enable = true;
    networking.networkmanager.plugins = with pkgs; [
      networkmanager-openvpn
    ];

    programs.ssh.startAgent = true;

    ### BLUETOOTH ###
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.extraConfig.bluetoothEnhancements = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-hw-volume" = true;
        };
      };
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };

    ### LOCALE ###
    time.timeZone = "Europe/Moscow";

    services.xserver.xkb.layout = "us, ru";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LANGUAGE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LC_CTYPE = "ru_RU.UTF-8";
      LC_COLLATE = "ru_RU.UTF-8";
      LC_TIME = "ru_RU.UTF-8";
      LC_MESSAGES = "ru_RU.UTF-8";
      LC_MONETARY = "ru_RU.UTF-8";
      LC_ADDRESS = "ru_RU.UTF-8";
    };

    ### ADMINISTRATION ###
    users.users.${user} = {
      isNormalUser = true;
      description = "${user}";
      extraGroups = ["networkmanager" "wheel" "video" "i2c"];
      shell = selfpkgs.shell;
    };
    programs.zsh.enable = true;
    environment.pathsToLink = [ "/share/zsh" ];

    environment.localBinInPath = true;

    security.polkit.enable = true;

    ### PACKAGES ####
    nixpkgs.config = {
      allowUnfree = true;
    };
    nixpkgs.overlays = [
      inputs.nur.overlays.default
      (final: _: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final.stdenv.hostPlatform) system;
          inherit (final) config;
        };
      })
    ];

    environment.systemPackages = with pkgs; [
      selfpkgs.shell
    ];

    ### GRAPHICS ###
    services.xserver.enable = true;
    services.xserver.videoDrivers = ["amdgpu"];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    preferences.login.autologin = true;

    system.stateVersion = "25.05";
  };
}
