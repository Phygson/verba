{
  config,
  lib,
  ...
}: let
  cfg = config.verba.wl-workarounds;
in {
  options.verba.wl-workarounds = {
    vscodium.enable = lib.mkEnableOption "VSCodium Wayland workaround";
    obsidian.enable = lib.mkEnableOption "Obsidian Wayland workaround";
  };

  config = {
    xdg.desktopEntries.obsidian-wl = lib.mkIf cfg.obsidian.enable {
      name = "Obsidian";
      exec = "obsidian --ozone-platform=wayland --ozone-platform-hint=auto --enable-features=UseOzonePlatform,WaylandWindowDecorations --socket=wayland --disable-gpu";
      terminal = false;
    };
    xdg.desktopEntries.VSCodium = lib.mkIf cfg.vscodium.enable {
      name = "VSCodium";
      exec = "codium --ozone-platform=wayland --ozone-platform-hint=auto --enable-features=UseOzonePlatform,WaylandWindowDecorations --socket=wayland --disable-gpu";
      terminal = false;
      settings = {
        StartupWMClass = "vscodium";
        Keywords = "vscode";
      };
    };
    programs.vscode.userSettings."window.titleBarStyle" = lib.mkIf cfg.vscodium.enable "custom";
  };
}
