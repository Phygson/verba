{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      output = [
        "eDP-1"
        "HDMI-A-1"
      ];

      modules-left = ["hyprland/workspaces"];
      modules-center = ["hyprland/window"];
      modules-right = ["hyprland/language"];

      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          "1" = "";
          "2" = "󰈹";
          "3" = "";
          "4" = "";
          active = "";
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
          "(.*) — Mozilla Firefox" = "󰈹  $1 󰈹 ";
          "(.*) - fish" = "󰈺  [$1]";
          "(.*) - VSCodium" = "  $1  ";
        };
        separate-outputs = true;
      };
    };
  };
}
