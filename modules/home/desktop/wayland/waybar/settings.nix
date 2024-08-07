{
  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      output = [
        "HDMI-A-1"
      ];
      margin-top = 5;

      modules-left = ["hyprland/workspaces"];
      modules-center = ["hyprland/window"];
      modules-right = ["hyprland/language" "mpd" "wireplumber" "cpu" "memory" "clock" "custom/notification"];

      clock = {
        interval = 60;
        format = "{:%H:%M}";
        max-length = 25;
        format-alt = "{:%d.%m.%y}";
      };

      cpu = {
        format = "{usage}% ";
        tooltip = false;
      };

      memory = {
        interval = 30;
        format = "{}% ";
      };

      wireplumber = {
        format = "{volume}% {icon}";
        format-muted = "";
        on-click = "pavucontrol";
        format-icons = ["" "" ""];
      };
      mpd = {
        format = "{stateIcon} {title}";
        format-disconnected = "Disconnected ";
        format-stopped = "Stopped ";
        interval = 10;
        consume-icons = {
          on = " ";
        };
        random-icons = {
          off = "<span color=\"#f53c3c\"></span> ";
          on = " ";
        };
        repeat-icons = {
          on = " ";
        };
        single-icons = {
          on = "1 ";
        };
        state-icons = {
          playing = "";
          paused = "";
        };
        tooltip-format = "MPD (connected)";
        tooltip-format-disconnected = "MPD (disconnected)";
        max-length = 40;
        on-click = "mpc toggle";
      };

      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          "1" = "";
          "2" = "󰈹";
          "3" = "";
          "4" = "";
          "5" = "";
          "6" = "󰓓";
          "7" = "󱞁";
          # active = "";
          default = "";
        };
        persistent-workspaces = {
          "*" = 9;
        };
      };

      "hyprland/language" = {
        format = "{}";
        format-en = "🇺🇸";
        format-ru = "🇷🇺";
        on-click = "hyprctl switchxkblayout gaming-keyboard next";
      };

      "hyprland/window" = {
        format = "{}";
        rewrite = {
          "(.*) — Mozilla Firefox" = "󰈹 $1";
          "(.*) - fish" = "󰈺 [$1]";
          "(.*) - VSCodium" = " $1";
        };
        separate-outputs = true;
        max-length = 45;
      };

      "custom/notification" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>";
          none = "";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
          inhibited-notification = "<span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "sleep 0.2s && swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;
      };
    };
  };
}
