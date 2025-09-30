{...}: {
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
  services.mpd-mpris.enable = true;

  programs.rmpc = {
    enable = true;
  };
}
