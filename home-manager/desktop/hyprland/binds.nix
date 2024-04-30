{
  lib,
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    settings = {
      "$mod" = "SUPER";
      bind = with pkgs.master;
        [
          "$mod, B, exec, firefox"
          "$mod, RETURN, exec, kitty"
          "$mod, W, killactive"
          "$mod, L, exec, gtklock -m ${gtklock-powerbar-module.out}/lib/gtklock/powerbar-module.so -m ${gtklock-playerctl-module.out}/lib/gtklock/playerctl-module.so"
          "SUPERALT, Q, exit"
          "$mod, D, exec, wofi -S drun"
          ", XF86AudioPlay, exec, mpc toggle"
          ", XF86AudioNext, exec, mpc next"
          ", XF86AudioPrev, exec, mpc prev"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
        );
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
