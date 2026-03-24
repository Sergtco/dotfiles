{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.lep-tep = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.lep-tep
      inputs.hjem.nixosModules.default
    ];
  };
  flake.nixosModules.lep-tep = {
    pkgs,
    inputs,
    ...
  }: let
    selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    hjem.users.sergtco.directory = "/home/sergtco";
    imports = [
      self.nixosModules.gaming
      self.nixosModules.programming
      self.nixosModules.zapret
      self.nixosModules.desktop
      self.nixosModules.theme
      self.nixosModules.vpn
      self.nixosModules.music
      self.nixosModules.kanata
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
    boot.initrd.kernelModules = ["amdgpu"];
    services.udev.packages = with pkgs; [via];

    ### DRIVES ###
    services.udisks2.enable = true;
    services.gvfs.enable = true;

    ### NETWORKING ###
    networking.hostName = "lep-tep";

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

    ### POWER ###
    powerManagement.enable = true;
    services.auto-cpufreq.enable = true;
    ### HARDWARE ###
    services.libinput.touchpad.naturalScrolling = true;

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
    users.extraGroups = {
      video = {};
    };
    users.users.sergtco = {
      isNormalUser = true;
      description = "sergtco";
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "uinput"
        "input"
      ];
      shell = selfpkgs.shell;
    };
    programs.zsh.enable = true;

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

    system.stateVersion = "25.05";
  };
}
