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

    plymouth.enable = true;

    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
  };

  ### KERNEL ###
  boot = {
    extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
    initrd.kernelModules = ["amdgpu"];
    kernelModules = ["ddcci-backlight"];
  };

  services.udev.packages = with pkgs; [via];

  ### DISPLAY ###
  hardware.i2c.enable = true;
  services.udev.extraRules = let
    bash = "${pkgs.bash}/bin/bash";
    ddcciDev = "AMDGPU DM aux hw bus 1";
    ddcciNode = "/sys/bus/i2c/devices/i2c-7/new_device";
  in ''
    SUBSYSTEM=="i2c", ACTION=="add", ATTR{name}=="${ddcciDev}", RUN+="${bash} -c 'sleep 30; printf ddcci\ 0x37 > ${ddcciNode}'"
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
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  ### ADMINISTRATION ###
  users.extraGroups = {
    video = {
      members = ["sergtco"];
    };
    i2c = {
      members = ["sergtco"];
    };
  };
  users.users.sergtco = {
    isNormalUser = true;
    description = "sergtco";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    useDefaultShell = true;
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  environment.shells = with pkgs; [zsh];

  security.polkit = {
    enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "sergtco";
  };

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
