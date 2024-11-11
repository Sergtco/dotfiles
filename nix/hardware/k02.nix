{
  pkgs,
  ...
}:

let
  qmk-hid-host = pkgs.callPackage ../pkgs/qmk-hid-host/qmk-hid-host.nix { };
in
{
  home.packages = [ qmk-hid-host ];

  systemd.user.services.qmk-hid-host = {
    Unit = {
      Description = "Start qmk-hid-host for keyboard multimedia display.";
    };
    Install = {
      WantedBy = [ "graphical.target" ];
    };
    Service = {
      ExecStart = "${qmk-hid-host}/bin/qmk-hid-host";
    };
  };
}
