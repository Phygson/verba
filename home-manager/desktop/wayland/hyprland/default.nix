{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./binds.nix
    ./settings.nix
  ];
  wayland.windowManager.hyprland = {
    package = pkgs.unstable.hyprland;
    enable = true;
    # enableNvidiaPatches = true;
    extraConfig = ''
      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = WLR_NO_HARDWARE_CURSORS,1
      env = ELECTRON_OZONE_PLATFORM_HINT,auto

      windowrule = float, ^(waypaper)$
      windowrule = center, ^(waypaper)$
      windowrule = size 69% 69%, ^(waypaper)$
    '';

    settings = {
      exec-once = [
        "swaync"
        "waypaper --restore"
        "waybar"
      ];
    };
  };
}
