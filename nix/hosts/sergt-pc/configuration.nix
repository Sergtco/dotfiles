{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/doh
    ../../modules/gaming
    ../../modules/programming
    ../../modules/music
    ../../modules/zapret
    ../../modules/utils
    ../../modules/virtualization
    ../../modules/desktop
    ../../modules/themes
    ../../modules/amdpu_patch
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

    initrd.verbose = false;
    consoleLogLevel = 0;
    plymouth.enable = true;
    kernelParams = ["quiet"];
  };

  ### KERNEL ###
  boot = {
    extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
    initrd.kernelModules = ["amdgpu"];
    kernelModules = ["ddcci_backlight" "nct6775"];
  };

  services.udev.packages = with pkgs; [via];

  ### RGBOFF
  services.hardware.openrgb.enable = true;

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
    options = [
      "defaults"
      "x-gvfs-show"
    ];
  };

  fileSystems."/mnt/chonky" = {
    label = "chonky";
    fsType = "ext4";
    options = [
      "defaults"
      "x-gvfs-show"
    ];
  };

  fileSystems."/mnt/fasty" = {
    label = "fasty";
    fsType = "ext4";
    options = [
      "defaults"
      "x-gvfs-show"
    ];
  };

  ### NETWORKING ###
  networking.hostName = "sergt-pc";

  networking.networkmanager.enable = true;

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
  users.extraGroups = {
    video.members = ["sergtco"];
    i2c.members = ["sergtco"];
  };

  users.users.sergtco = {
    isNormalUser = true;
    description = "sergtco";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  environment.localBinInPath = true;

  security.polkit = {
    enable = true;
  };

  ### PACKAGES ####
  nixpkgs.config = {
    allowUnfree = true;
  };
  nixpkgs.overlays = [
    (final: _: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final.stdenv.hostPlatform) system;
        inherit (final) config;
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    #cli
    bash
    bottom
    curl
    p7zip
    zip
    unzip
    git
    killall
    wget
    wl-clipboard
    xclip
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    corefonts
    noto-fonts-color-emoji
  ];
  ### GRAPHICS ###
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.greetd = {
    enable = true;
    settings.initial_session = {
      command = "${pkgs.uwsm}/bin/uwsm start -- hyprland-uwsm.desktop";
      user = "sergtco";
    };
  };

  programs.regreet.enable = true;

  programs = {
    hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
      withUWSM = true;
    };
    hyprlock.enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };
  services.hypridle.enable = true;

  ### NIX ###
  nix.settings = {
    builders-use-substitutes = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  system.stateVersion = "25.05";
}
