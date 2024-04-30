{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.z.prismlauncher;
in {
  options.z.prismlauncher = {
    enable = mkEnableOption "Prism Launcher";
    enableWayland = mkEnableOption "Enable running Minecraft natively under Wayland";
    package = mkOption {
      type = types.package;
      default = pkgs.prismlauncher;
    };
    javaPackages = mkOption {
      type = types.listOf types.package;
      default = [pkgs.temurin-jre-bin-8];
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      (cfg.package.override {
        jdks = cfg.javaPackages;
        withWaylandGLFW = cfg.enableWayland;
      })
    ];
  };
}
