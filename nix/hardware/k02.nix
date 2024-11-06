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
  qmk-hid-host = pkgs.callPackage ../pkgs/qmk-hid-host/qmk-hid-host.nix { };
in
{
  home.packages = with pkgs; [ qmk-hid-host ];

  systemd.user.services.qmk-hid-host = {
    Unit = {
      Description = "Start qmk-hid-host for keyboard multimedia display.";
    };
    Install = {
      WantedBy = [ "default.target" ];
      Wants = [ "default.target" ];
      After = [ "default.target" ];
    };
    Service = {
      ExecStart = "${qmk-hid-host}/bin/qmk-hid-host";
    };
  };
}
