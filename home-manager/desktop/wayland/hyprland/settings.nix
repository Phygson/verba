{
  lib,
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    general = {
      "gaps_in" = "2";
      "gaps_out" = "5";
      "border_size" = "2";
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";
    };
    decoration = {
      "rounding" = "3";
      "drop_shadow" = "yes";
      "shadow_range" = "4";
      "shadow_render_power" = "3";
      "col.shadow" = "rgba(1a1a1aee)";
    };
    input = {
      "kb_layout" = "us,ru";
      "kb_options" = "grp:alt_shift_toggle";
      "follow_mouse" = "1";
    };
    animations = {
      "enabled" = "yes";
      "bezier" = "myBezier, 0.05, 0.9, 0.1, 1.05";

      "animation" = [
        "windows, 1, 3, myBezier"
        "windowsOut, 1, 3, default, popin 80%"
        "border, 1, 4, default"
        "fade, 1, 3, default"
        "workspaces, 1, 2, default"
      ];
    };
  };
}
