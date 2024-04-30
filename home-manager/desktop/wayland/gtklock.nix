{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.z.gtklock;
in {
  options.z.gtklock = {
    enable = mkEnableOption "gtklock";
    hyprland = {
      enable = mkEnableOption "Hyprland integration";
      enableUserinfoModule = mkEnableOption "userinfo-module";
      enablePowerbarModule = mkEnableOption "powerbar-module";
      enablePlayectlModule = mkEnableOption "playerctl-module";
      mod = mkOption {
        type = types.str;
        default = "SUPER";
      };
      key = mkOption {
        type = types.str;
        default = "L";
      };
    };
    pkgsInstance = mkOption {
      type = types.pkgs;
      default = pkgs;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.pkgsInstance.gtklock
    ];

    wayland.windowManager.hyprland.settings.bind = with cfg.pkgsInstance;
    with cfg.hyprland;
      mkIf enable [
        (mod
          + ", "
          + key
          + ", exec, gtklock "
          + builtins.concatStringsSep "" [
            (optionalString enablePowerbarModule " -m ${gtklock-powerbar-module.out}/lib/gtklock/powerbar-module.so")
            (optionalString enablePlayectlModule " -m ${gtklock-playerctl-module.out}/lib/gtklock/playerctl-module.so")
            (optionalString enableUserinfoModule " -m ${gtklock-userinfo-module.out}/lib/gtklock/userinfo-module.so")
          ])
      ];
  };
}
