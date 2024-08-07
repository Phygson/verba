{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.verba.gtklock;
in {
  options.verba.gtklock = {
    enable = lib.mkEnableOption "gtklock";
    hyprland = {
      enable = lib.mkEnableOption "Hyprland integration";
      enableUserinfoModule = lib.mkEnableOption "userinfo-module";
      enablePowerbarModule = lib.mkEnableOption "powerbar-module";
      enablePlayectlModule = lib.mkEnableOption "playerctl-module";
      mod = lib.mkOption {
        type = lib.types.str;
        default = "SUPER";
      };
      key = lib.mkOption {
        type = lib.types.str;
        default = "L";
      };
    };
    pkgsInstance = lib.mkOption {
      type = lib.types.pkgs;
      default = pkgs;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.pkgsInstance.gtklock
    ];

    wayland.windowManager.hyprland.settings.bind = lib.mkIf cfg.hyprland.enable [
      (
        cfg.hyprland.mod
        + ", "
        + cfg.hyprland.key
        + ", exec, gtklock "
        + (lib.optionalString cfg.hyprland.enablePowerbarModule " -m ${cfg.pkgsInstance.gtklock-powerbar-module.out}/lib/gtklock/powerbar-module.so")
        + (lib.optionalString cfg.hyprland.enablePlayectlModule " -m ${cfg.pkgsInstance.gtklock-playerctl-module.out}/lib/gtklock/playerctl-module.so")
        + (lib.optionalString cfg.hyprland.enableUserinfoModule " -m ${cfg.pkgsInstance.gtklock-userinfo-module.out}/lib/gtklock/userinfo-module.so")
      )
    ];
  };
}
