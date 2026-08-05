{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.lep-tep = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.lep-tep
      inputs.hjem.nixosModules.default
    ];
  };
  flake.nixosModules.lep-tep =
    { config, ... }:
    let
      user = config.preferences.user.name;
    in
    {
      imports = [
        self.nixosModules.linux-base
        self.nixosModules.graphics-amd

        self.nixosModules.desktop
        self.nixosModules.theme
        self.nixosModules.gaming
        self.nixosModules.programming
        self.nixosModules.music
        self.nixosModules.zapret
        self.nixosModules.vpn
        self.nixosModules.kanata
      ];

      networking.hostName = "lep-tep";

      # uinput/input: kanata needs to read and synthesise key events.
      users.users.${user}.extraGroups = [
        "uinput"
        "input"
      ];

      ### POWER ###
      powerManagement.enable = true;
      services.auto-cpufreq.enable = true;

      ### HARDWARE ###
      services.libinput.touchpad.naturalScrolling = true;
    };
}
