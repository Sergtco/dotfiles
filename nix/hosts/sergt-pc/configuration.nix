{
  config,
  pkgs,
  inputs,
  ...
}:
let
  unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ./programming.nix
    ./gaming.nix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      theme = "${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze";
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  boot.kernelModules = [ "i2c-dev" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.udev = {
    extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    '';
    packages = with pkgs; [ via ];
  };

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  fileSystems."/mnt/hard" = {
    label = "hard";
    fsType = "ext4";
    options = [
      "defaults"
      "users"
      "x-gvfs-show"
    ];
  };

  fileSystems."/mnt/chonky" = {
    label = "chonky";
    fsType = "ext4";
    options = [
      "defaults"
      "users"
      "x-gvfs-show"
    ];
  };

  networking.hostName = "sergt-pc";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ amdvlk ];
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  };
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
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [
          "a2dp_sink"
          "a2dp_source"
          "bap_sink"
          "bap_source"
          "hsp_hs"
          "hsp_ag"
          "hfp_hf"
          "hfp_ag"
        ];
      };
    };
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

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

  users.defaultUserShell = pkgs.zsh;
  users.users.sergtco = {
    isNormalUser = true;
    description = "sergtco";
    extraGroups = [
      "networkmanager"
      "wheel"
      "i2c"
    ];
    useDefaultShell = true;
    packages = with pkgs; [ ];
  };

  security.polkit = {
    enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical.target" ];
      wants = [ "graphical.target" ];
      after = [ "graphical.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  environment.shells = with pkgs; [ zsh ];

  environment.systemPackages = with pkgs; [
    #gui
    firefox
    hyprpaper
    kitty
    pavucontrol
    cinnamon.nemo
    #cli
    bash
    bottom
    curl
    p7zip
    fd
    git
    killall
    nixfmt-rfc-style
    ripgrep
    udiskie
    vim
    wget
    wl-clipboard
    xclip

    #need them
    ddcutil
  ];
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "JetBrainsMono"
      ];
    })
    corefonts
  ];

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us, ru";
      variant = "";
    };
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
  programs.nix-ld.enable = true;
  programs = {
    hyprland = {
      enable = true;

      xwayland.enable = true;
    };
    hyprlock.enable = true;
  };
  services.hypridle.enable = true;

  programs.zsh.enable = true;

  ## delete after litivin
  virtualisation.vmware = {
    host.enable = true;
  };

  system.stateVersion = "24.05";
}
