{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom.desktop;
in {
  options.custom.desktop = {
    enable = lib.mkEnableOption "Desktop parts";
    autologin = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      tumbler.enable = true;
      blueman.enable = true;

      printing.enable = true;
      printing.drivers = with pkgs; [
        canon-cups-ufr2
      ];
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };

    ### Enable thunar fm
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    programs.gpu-screen-recorder.enable = true;

    environment.systemPackages = with pkgs; [
      gpu-screen-recorder
      gpu-screen-recorder-gtk
      ffmpeg
      gnome-disk-utility
      xarchiver
      rar
      gimp3
    ];

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

    ### LOGIN ###

    services.greetd = {
      enable = true;
      settings.initial_session = lib.mkIf cfg.autologin {
        command = "${pkgs.uwsm}/bin/uwsm start -- hyprland-uwsm.desktop";
        user = "sergtco";
      };
    };

    programs.regreet.enable = true;
  };
}
