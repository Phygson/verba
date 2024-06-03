{...}: {
  xdg.desktopEntries = {
    obsidian-wl = {
      name = "Obsidian-wl";
      exec = "obsidian --ozone-platform=wayland --ozone-platform-hint=auto --enable-features=UseOzonePlatform,WaylandWindowDecorations --socket=wayland --disable-gpu";
      terminal = false;
    };
    VSCodium-wl = {
      name = "VSCodium-wl";
      exec = "codium --ozone-platform=wayland --ozone-platform-hint=auto --enable-features=UseOzonePlatform,WaylandWindowDecorations --socket=wayland --disable-gpu";
      terminal = false;
    };
  };
  programs.vscode.userSettings."window.titleBarStyle" = "custom";
}
