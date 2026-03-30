{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
      user = config.preferences.user.name;
    in
    {
      services = {
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

      programs.gpu-screen-recorder.enable = true;

      environment.systemPackages = with pkgs; [
        gpu-screen-recorder-gtk
        gnome-disk-utility
        calibre
        xarchiver
        pcmanfm
        shared-mime-info # pcmanfm
        gimp3
        zathura
        wl-clipboard
        xclip

        playerctl
        telegram-desktop
        element-desktop
        transmission_4-qt
        vial
        vesktop
        libreoffice-qt-fresh
        wine

        pavucontrol
        mpv
        gedit
        swayimg
        brightnessctl
        thunderbird
        spotify

        selfpkgs.helium
        selfpkgs.alacritty

        libnotify
        (pkgs.writeShellScriptBin "toggle-notification" (
          builtins.readFile ../../../scripts/toggle-notification.sh
        ))
      ];

      programs.localsend.enable = true;
      programs = {
        niri = {
          enable = true;
          useNautilus = false;
          package = selfpkgs.niri;
        };
        hyprlock.enable = true;
        waybar = {
          enable = true;
          package = selfpkgs.waybar;
        };
      };

      services = {
        hypridle.enable = true;
        hypridle.package = selfpkgs.hypridle;
        gnome.gcr-ssh-agent.enable = false;
        udisks2.enable = true;
      };

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-gnome
          pkgs.xdg-desktop-portal-hyprland
        ];
        config = {
          niri = {
            default = [
              "gtk"
              "gnome"
            ];
            "org.freedesktop.portal.ScreenCast" = [ "gnome" ];
            "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          };
        };
      };

      ### LOGIN ###
      services.greetd = {
        enable = true;
        settings = {
          initial_session = lib.mkIf config.preferences.login.autologin {
            command = "/run/current-system/sw/bin/niri-session";
            user = "sergtco";
          };
          default_session = {
            command = "${lib.getExe pkgs.tuigreet} --remember --remember-user-session --cmd niri-session";
            user = "greeter";
          };
        };
        useTextGreeter = true;
      };

      programs.seahorse.enable = true;
      services.gnome.gnome-keyring.enable = true;
      security.pam.services = {
        greetd.enableGnomeKeyring = true;
        greetd-password.enableGnomeKeyring = true;
        login.enableGnomeKeyring = true;
      };
      services.dbus.packages = [
        pkgs.gnome-keyring
        pkgs.gcr
      ];
    };
}
