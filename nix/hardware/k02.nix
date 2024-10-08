{pkgs, ...}: let
  qmk-hid-host = pkgs.callPackage ../pkgs/qmk-hid-host {};
in {
  home.packages = [qmk-hid-host];

  systemd.user.services.qmk-hid-host = {
    Unit = {
      Description = "Start qmk-hid-host for keyboard multimedia display.";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${qmk-hid-host}/bin/qmk-hid-host";
    };
  };
}
