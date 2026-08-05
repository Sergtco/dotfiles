{ self, ... }:
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
        printing.enable = true;

        avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
        };

        hypridle.enable = true;
        hypridle.package = selfpkgs.hypridle;

        # gnome-keyring provides the ssh agent instead, see below.
        gnome.gcr-ssh-agent.enable = false;
      };

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
        unstable.telegram-desktop
        transmission_4-qt
        vial
        vesktop
        libreoffice-qt-fresh
        wine

        wiremix
        bluetui
        mpv
        gedit
        swayimg
        thunderbird
        spotify
        packet

        selfpkgs.helium
        selfpkgs.neovim
        selfpkgs.alacritty

        libnotify
        (pkgs.writeShellScriptBin "toggle-notification" (
          builtins.readFile ../../../scripts/toggle-notification.sh
        ))
      ];
      networking.firewall.allowedTCPPorts = [
        9300 # packet quickshare
      ];
      networking.firewall.allowedUDPPorts = [
        9300 # packet quickshare
      ];

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
        gpu-screen-recorder.enable = true;
      };

      xdg.portal = {
        enable = true;
        config = {
          niri = {
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
            command = "/run/current-system/sw/bin/niri-session -l";
            inherit user;
          };
          default_session = {
            command = "${lib.getExe pkgs.tuigreet} --remember --remember-user-session --cmd 'niri-session -l'";
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
      services.xserver.displayManager.sessionCommands = ''
        eval $(gnome-keyring-daemon --start --daemonize --components=ssh,secrets)
        export SSH_AUTH_SOCK
      '';
    };
}
