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
  ];

  ### BOOTLOADER ###
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        theme = "${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze";
        efiSupport = true;
        device = "nodev";
        useOSProber = false;
      };
    };

    plymouth = {
      enable = true;
      theme = "lone";
      themePackages = [(pkgs.adi1090x-plymouth-themes.override {selected_themes = ["lone"];})];
    };

    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };

  ### KERNEL ###
  boot.extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
  boot.kernelModules = [
    "i2c-dev"
    "ddcci_backlight"
  ];
  boot.initrd.kernelModules = ["amdgpu"];
  services.udev = {
    extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    '';
    packages = with pkgs; [via];
  };

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

  ### NETWORKING ###
  networking.hostName = "sergt-pc";

  networking.networkmanager.enable = true;

  programs.ssh = {
    startAgent = true;
  };

  ### BLUETOOTH ###
  # rtkit is optional but recommended
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
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  ### LOCALE ###
  time.timeZone = "Europe/Moscow";

  services.xserver.xkb = {
    layout = "us, ru";
    variant = "";
  };

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
    i2c = {};
    video = {};
  };
  users.users.sergtco = {
    isNormalUser = true;
    description = "sergtco";
    extraGroups = [
      "networkmanager"
      "wheel"
      "i2c"
      "video"
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
    services.shadowsocks-proxy = {
      wantedBy = ["default.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.shadowsocks-rust}/bin/sslocal -c /home/sergtco/shadowsocks.json";
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
    #gui
    firefox
    kitty
    pavucontrol
    vlc
    xfce.thunar
    gedit
    swayimg

    #cli
    bash
    bottom
    curl
    p7zip
    zip
    unzip
    git
    killall
    nixfmt-rfc-style
    wget
    wl-clipboard
    xclip

    #need them
    brightnessctl
  ];
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "JetBrainsMono"
      ];
    })
    corefonts
    noto-fonts-color-emoji
  ];
  ### GRAPHICS ###
  services.xserver.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [amdvlk];
    extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
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

  system.stateVersion = "24.11";
}
