{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.z.screenshot;
in {
  options.z.screenshot = {
    enable = mkEnableOption "z screenshot";
    enableXDG = mkOption {
      type = types.bool;
      default = true;
    };
    dir = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/Pictures/Screenshots";
    };
    dateFormat = mkOption {
      type = types.str;
      default = "%Y%m%d-%H%M%S";
    };
    hyprland = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
      bind.copy = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
        bind = mkOption {
          type = types.listOf types.str;
          default = ["$mod" "S"];
        };
      };
      bind.copysave = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
        bind = mkOption {
          type = types.listOf types.str;
          default = ["SHIFT $mod" "S"];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.grimblast];
    xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR = mkIf cfg.enableXDG cfg.dir;
    wayland.windowManager.hyprland.settings.bind =
      optionals (cfg.hyprland.enable && cfg.hyprland.bind.copy.enable) [
        (with cfg.hyprland.bind.copy;
          builtins.elemAt bind 0
          + ", "
          + builtins.elemAt bind 1
          + ", exec, grimblast --notify copy area")
      ]
      ++ optionals (cfg.hyprland.enable && cfg.hyprland.bind.copysave.enable) [
        (with cfg.hyprland.bind.copysave;
          builtins.elemAt bind 0
          + ", "
          + builtins.elemAt bind 1
          + ", exec, grimblast --notify copysave area"
          + cfg.dir
          + "/$(date +\""
          + cfg.dateFormat
          + "\").png")
      ];
  };
}
