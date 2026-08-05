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
        grub = {
          efiSupport = true;
          device = "nodev";
          timeoutStyle = "hidden";
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
