{ self, ... }:
{
  # Everything every NixOS host here wants regardless of what it is used for:
  # bootloader, network, audio, the primary user account and the nixpkgs setup.
  # Anything a host could plausibly not want belongs in a feature module instead.
  flake.nixosModules.linux-base =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
      user = config.preferences.user.name;
    in
    {
      imports = [
        self.nixosModules.base
        self.nixosModules.locale
        self.nixosModules.audio
        self.nixosModules.fonts
        self.nixosModules.nix
      ];

      hjem.users.${user}.directory = "/home/${user}";

      ### BOOTLOADER ###
      boot.loader = {
        efi.canTouchEfiVariables = true;
        # 0 skips the menu wait entirely; hold Space during POST to bring the
        # menu back for a rollback.
        timeout = 0;
        systemd-boot = {
          enable = true;
          # Kernels and initrds sit on the ESP, which is 639M on sergt-pc, so
          # the NixOS default of 100 generations does not come close to fitting.
          configurationLimit = 10;
        };
      };

      ### DRIVES ###
      services.udisks2.enable = true;
      services.gvfs.enable = true;

      ### NETWORKING ###
      networking.networkmanager.enable = true;
      networking.networkmanager.plugins = with pkgs; [
        networkmanager-openvpn
      ];

      programs.ssh.startAgent = true;

      ### PERIPHERALS ###
      services.udev.packages = with pkgs; [ via ];

      ### ADMINISTRATION ###
      users.users.${user} = {
        isNormalUser = true;
        description = user;
        extraGroups = [
          "networkmanager"
          "wheel"
          "video"
        ];
        shell = lib.getExe selfpkgs.env;
      };

      environment.localBinInPath = true;
      security.polkit.enable = true;

      ### PACKAGES ###
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [
        self.overlays.nur
        self.overlays.unstable
      ];

      environment.systemPackages = [ selfpkgs.env ];

      system.stateVersion = "25.05";
    };
}
