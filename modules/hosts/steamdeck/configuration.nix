{
  inputs,
  self,
  ...
}:
{
  # Jovian only validates against nixos-unstable, so this is the one host that
  # builds from `nixpkgs-unstable` instead of the pinned release. Everything
  # pulled in from `self.packages` is still built against the stable nixpkgs,
  # the same way `pkgs.unstable.*` is used the other way around elsewhere.
  flake.nixosConfigurations.steamdeck = inputs.nixpkgs-unstable.lib.nixosSystem {
    modules = [
      self.nixosModules.steamdeck
      inputs.hjem.nixosModules.default
    ];
  };

  flake.nixosModules.steamdeck =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      user = config.preferences.user.name;
      # sergt-pc and lep-tep: the machines that build and push to this one.
      adminKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIONQl57Uy5ozD/s+dZM2q99uj3q1GZK5hw8gDxAU3hZa sergt-pc"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbsx8ktNrZIqWALY8dX36CWhCC9jrDhFlqMxVhK6ko6 lep-tep"
      ];
    in
    {
      imports = [
        inputs.jovian.nixosModules.default

        self.nixosModules.linux-base
        self.nixosModules.graphics-amd

        self.nixosModules.desktop
        self.nixosModules.theme
        self.nixosModules.zapret
      ];

      networking.hostName = "steamdeck";

      ### GAMING MODE ###
      # Jovian is the whole SteamOS userland: Valve's kernel, the Deck UI
      # (gamescope-session), steamos-manager, the fan curve, mura correction,
      # the vendor Mesa branches.
      #
      # `gaming` is deliberately not imported. It builds a gamescope session
      # for a 2560x1440 HDR monitor and ships a `steamos-session-select` stub,
      # both of which the real Deck session replaces — importing it would only
      # add a second, unused session and a binary collision.
      jovian = {
        devices.steamdeck = {
          enable = true;
          # Run the BIOS and controller firmware updaters at boot, as SteamOS
          # does. Off by default upstream; on here because the alternative is
          # firmware drifting until someone remembers to update it by hand.
          autoUpdate = true;
          # Gyro exposed as a Cemuhook DSU server, which is what emulators read.
          enableGyroDsuService = true;
        };

        steam = {
          enable = true;
          # Boot straight into Gaming Mode. This is what makes "Switch to
          # Desktop" work at all, and it brings its own display manager along
          # (SDDM with autologin), see the greetd override below.
          autoStart = true;
          inherit user;
          # "Switch to Desktop" lands in niri; quitting niri (Mod+Shift+E)
          # comes back here.
          desktopSession = "niri";
        };

        # zram, earlyoom, the SteamOS sysctls and bluetooth defaults, SD card
        # automount. Implied by `steam.enable`, spelled out because it is what
        # makes this a SteamOS-alike rather than NixOS with Steam on it.
        steamos.useSteamOSConfig = true;

        decky-loader.enable = true;
      };

      # Jovian forwards these into the gamescope session, which is the only way
      # to get a layout other than us into Gaming Mode and its on-screen
      # keyboard.
      environment.variables = {
        XKB_DEFAULT_LAYOUT = "us,ru";
        XKB_DEFAULT_OPTIONS = "grp:win_space_toggle";
      };

      # Jovian enables desktop Steam itself, this is only the extra bits the
      # other hosts get from `gaming`.
      programs.steam = {
        extraCompatPackages = [ pkgs.proton-ge-bin ];
        protontricks.enable = true;
      };

      environment.systemPackages = [
        # The updaters `autoUpdate` runs at boot, in PATH as well, so
        # `sudo jupiter-biosupdate` and `sudo jupiter-controller-update` can be
        # run by hand between reboots.
        pkgs.steamdeck-firmware
        # `pkgs` is nixpkgs-unstable on this host, so this is already the
        # unstable build; going through the `unstable` overlay instead would
        # fetch a second webkitgtk rather than share the system's.
        pkgs.stremio-linux-shell
      ];

      ### REMOTE ACCESS ###
      # The one host here without a keyboard of its own: Gaming Mode has no
      # terminal and Desktop Mode wants one plugged in, so ssh is how this
      # machine gets administered. Root by key as well, because that is what
      # nixos-anywhere and `nixos-rebuild --target-host` reach for, and there
      # is no root password to fall back on.
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "prohibit-password";
        };
      };

      users.users.${user}.openssh.authorizedKeys.keys = adminKeys;
      users.users.root.openssh.authorizedKeys.keys = adminKeys;

      ### LOGIN ###
      # `desktop` sets up greetd, but Gaming Mode's autostart wants SDDM with
      # autologin and the two cannot both own display-manager.service.
      services.greetd.enable = lib.mkForce false;
      security.pam.services.sddm.enableGnomeKeyring = true;

      ### DISPLAY ###
      # Internal panel, so the kernel backlight class is the thing to write to.
      # Jovian already loosens the permissions on those device nodes.
      preferences.brightness.backend = "brightnessctl";

      # Nothing rotates the panel here on purpose. It scans out 800x1280, but
      # the kernel quirk table reports its orientation for both Jupiter and
      # Galileo, and niri reads that DRM property and *composes* it with the
      # configured transform — so asking for 270 on top of the detected 270
      # would land upside-down. The shared niri config's `eDP-1` mode is the
      # laptop's 1920x1080, which does not exist here; niri falls back to the
      # preferred mode.

      # SteamOS runs the desktop Steam client in Desktop Mode as well — that is
      # what puts it in the tray and gives the Steam button chords something to
      # talk to there. Bound to niri rather than dropped in /etc/xdg/autostart
      # so it cannot start inside Gaming Mode, which has a Steam of its own.
      systemd.user.services.steam-desktop = {
        description = "Steam client in the niri session, as SteamOS runs it in Desktop Mode";
        after = [ "niri.service" ];
        partOf = [ "niri.service" ];
        wantedBy = [ "niri.service" ];
        serviceConfig = {
          Type = "simple";
          # -silent starts it into the tray instead of opening the window.
          ExecStart = "${lib.getExe config.programs.steam.package} -silent";
          # Quitting Steam from the tray should stay quit.
          Restart = "no";
        };
      };

      ### BOOT ###
      # Every generation on the ESP is a Valve kernel plus its initrd, so the
      # 10 that `linux-base` keeps do not fit in a Deck-sized boot partition.
      boot.loader.systemd-boot.configurationLimit = lib.mkForce 5;
      # There is no keyboard to hold Space on, so the menu is only really
      # reachable docked — still worth the three seconds for a rollback.
      # (The firmware boot menu is Volume Down + Power.)
      boot.loader.timeout = lib.mkForce 3;
    };
}
