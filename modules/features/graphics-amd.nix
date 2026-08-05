_: {
  flake.nixosModules.graphics-amd = _: {
    boot.initrd.kernelModules = [ "amdgpu" ];

    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
