{
  lib,
  config,
  pkgs,
  ...
}: {
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
    forceFullCompositionPipeline = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
