{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/gaming
    ../../modules/programming
    ../../modules/zapret
    ../../modules/utils
    ../../modules/desktop
    ../../modules/themes
    ../../modules/virtualization
    ../../modules/vpn
    ../../modules/kanata.nix
  ];

  ### BOOTLOADER ###
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        efiSupport = true;
        device = "nodev";
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
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };
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
    shell = pkgs.zsh;
  };

  environment.localBinInPath = true;
  programs.zsh.enable = true;

  security.polkit.enable = true;

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
    (final: prev: {
      inherit
        (prev.lixPackageSets.latest)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];
  nix.package = pkgs.lixPackageSets.latest.lix;

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

  custom.desktop = {
    enable = true;
  };

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
