{
  lib,
  config,
  pkgs,
  ...
}: {
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot"; # ← use the same mount point here.
    };
    grub = {
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      copyKernels = true;
      extraEntries = ''           
        menuentry "Reboot" {
          reboot
        }

        menuentry "Shut Down" {
          halt
        }'';
    };
  };
}
