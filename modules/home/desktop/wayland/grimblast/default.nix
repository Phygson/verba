{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.z.grimblast;
in {
  options.z.grimblast = {
    enable = lib.mkEnableOption "z grimblast";
    enableXDG = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    dir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Pictures/Screenshots";
    };
    dateFormat = lib.mkOption {
      type = lib.types.str;
      default = "%Y%m%d-%H%M%S";
    };
    hyprland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      bind.copy = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        bind = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = ["$mod" "S"];
        };
      };
      bind.copysave = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        bind = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = ["SHIFT $mod" "S"];
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.grimblast];
    xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR = lib.mkIf cfg.enableXDG cfg.dir;
    wayland.windowManager.hyprland.settings.bind =
      lib.optionals (cfg.hyprland.enable && cfg.hyprland.bind.copy.enable) [
        (builtins.elemAt cfg.hyprland.bind.copy.bind 0
          + ", "
          + builtins.elemAt cfg.hyprland.bind.copy.bind 1
          + ", exec, grimblast --notify copy area")
      ]
      ++ lib.optionals (cfg.hyprland.enable && cfg.hyprland.bind.copysave.enable) [
        (builtins.elemAt cfg.hyprland.bind.copysave.bind 0
          + ", "
          + builtins.elemAt cfg.hyprland.bind.copysave.bind 1
          + ", exec, grimblast --notify copysave area ${cfg.dir}/$(date +\"${cfg.dateFormat}\").png")
      ];
  };
}
