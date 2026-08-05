{ self, inputs, ... }:
{
  config = {
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    perSystem =
      { system, ... }:
      {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            self.overlays.nur
            self.overlays.unstable
          ];
          config = {
            allowUnfree = true;
          };
        };
      };
  };
}
