{ self, inputs, ... }:
{
  config = {
    systems = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];

    perSystem =
      { system, ... }:
      {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            self.overlays.nur
            self.overlays.unstable
            self.overlays.xwayland-satellite
          ];
          config = {
            allowUnfree = true;
          };
        };
      };
  };
}
