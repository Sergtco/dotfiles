{pkgs, ...}: {
  services.mpd = {
    enable = true;
    musicDirectory = "/home/sergtco/Music";
    extraConfig = ''
      audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
    '';
    network.startWhenNeeded = true;
  };

  systemd.user.services.mpdris2-rs = {
    Unit = {
      Description = "Music Player Daemon D-Bus Bridge";
      Wants = "mpd.service";
      After = "mpd.service";
    };
    Service = {
      Type = "dbus";
      BusName = "org.mpris.MediaPlayer2.mpd";
      Restart = "on-failure";
      ExecStart = "${pkgs.mpdris2-rs}/bin/mpdris2-rs";
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };

  programs.rmpc = {
    enable = true;
  };
}
