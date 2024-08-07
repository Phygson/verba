{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.verba.prismlauncher;
in {
  options.verba.prismlauncher = {
    enable = lib.mkEnableOption "Prism Launcher";
    enableWayland = lib.mkEnableOption "Enable running Minecraft natively under Wayland";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.prismlauncher;
    };
    javaPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [pkgs.temurin-jre-bin-8];
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (cfg.package.override {
        jdks = cfg.javaPackages;
        withWaylandGLFW = cfg.enableWayland;
      })
    ];
  };
}
