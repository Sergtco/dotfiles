_: {
  # Pipewire + bluetooth. The two are together because the interesting bluetooth
  # settings here (SBC XQ, hardware volume) are wireplumber-side.
  flake.nixosModules.audio = _: {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.extraConfig.bluetoothEnhancements = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-hw-volume" = true;
        };
      };
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };
  };
}
