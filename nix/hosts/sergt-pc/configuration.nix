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
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.udisks2.enable = true;
  fileSystems."/mnt/hard" = {
    label = "hard";
    fsType = "ext4";
  };

  fileSystems."/mnt/lin_hard" = {
    label = "chonky";
    fsType = "ext4";
  };

  networking.hostName = "sergt-pc";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.roles" = [
        "hsp_hs"
        "hsp_ag"
        "hfp_hf"
        "hfp_ag"
      ];
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

  services.xserver = {
    xkb = {
      layout = "us, ru";
      variant = "";
    };
  };

  users.users.sergtco = {
    isNormalUser = true;
    description = "sergtco";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  security.polkit = {
    enable = true;
  };

  systemd = {
    user.services = {
      polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
      #dpi
      byedpi = {
        enable = true;
        serviceConfig = {
          ExecStart = "${unstable.byedpi}/bin/ciadpi -s1 -q1 -Y -Ar -s5 -o1+s -At -f-1 -r1+s -As -s1 -o1 +s -s-1 -An";
        };
        wantedBy = [ "multi-user.target" ];
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
    #cli
    bash
    bottom
    curl
    fd
    git
    killall
    nixfmt-rfc-style
    ripgrep
    udiskie
    unstable.neovim
    wget
    wl-clipboard
    xclip
  ];
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "JetBrainsMono"
      ];
    })
  ];

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
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
