{
  pkgs,
  inputs,
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
    kernelParams = ["quiet"];
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
    useDefaultShell = true;
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  environment.shells = with pkgs; [zsh];

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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
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

  ### KEYBOARD ###
  services.kanata = {
    enable = true;
    keyboards = {
      internal = {
        devices = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt menu rctl
          )

          (defvar
            tap-time 200
            hold-time 150
          )

          (deflayermap (base)
            tab  esc
            lalt tab
            spc  (tap-hold $tap-time $hold-time spc (layer-while-held nav))
            ralt (tap-hold $tap-time $hold-time ralt   (layer-while-held layers))
            a    (tap-hold $tap-time $hold-time a   lmet)
            s    (tap-hold $tap-time $hold-time s   lalt)
            d    (tap-hold $tap-time $hold-time d   lctl)
            f    (tap-hold $tap-time $hold-time f   lsft)
            j    (tap-hold $tap-time $hold-time j   rsft)
            k    (tap-hold $tap-time $hold-time k   rctl)
            l    (tap-hold $tap-time $hold-time l   ralt)
            ;    (tap-hold $tap-time $hold-time ;   rmet)
          )

          (deflayermap (nav)
            e up
            s left
            d down
            f right
          )

          (deflayermap (layers)
            1 (layer-switch base)
            2 (layer-switch clean)
          )

          (deflayermap (clean)
            ralt (tap-hold $tap-time $hold-time ralt   (layer-while-held layers))
          )
        '';
      };
    };
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
