{pkgs, ...}: let
  kidex = pkgs.callPackage ./kidex.nix {};
in {
  systemd.user.services.kidex = {
    Unit = {
      Description = "A simple file indexing service for looking up file locations.";
    };
    Install = {
      WantedBy = ["multi-user.target"];
    };
    Service = {
      ExecStart = "${kidex}/bin/kidex";
    };
  };
  xdg.configFile."kidex.ron".text =
    #ron
    ''
      Config(
        ignored: [], // A list of patterns to be ignored in all directories
        directories: [
          WatchDir(
            path: "/home/sergtco/Documents", // The root folder to be indexed
            recurse: true, // Recursively index and watch all subfolders
            ignored: [], // Ignore patterns specifically for this directory
          ),
        ],
      )
    '';
}
