{pkgs, ...}: {
  imports = [
    ./binds.nix
    ./settings.nix
  ];
  wayland.windowManager.hyprland = {
    package = pkgs.hyprland;
    enable = true;
    extraConfig = ''
      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = WLR_NO_HARDWARE_CURSORS,1
      env = ELECTRON_OZONE_PLATFORM_HINT,auto
      env = NIXOS_OZONE_WL,1

      windowrule = float, ^(waypaper)$
      windowrule = center, ^(waypaper)$
      windowrule = size 69% 69%, ^(waypaper)$
    '';

    settings = {
      monitor = [
        "HDMI-A-1,1920x1080@60,0x0,1"
        "Unknown-1,disable"
      ];
      exec-once = [
        "swaync"
        "waypaper --restore"
        "waybar"
      ];
    };
  };
}
