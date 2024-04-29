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
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          active = "";
          default = "";
        };
        persistent-workspaces = {
          "*" = 9;
        };
      };

      "hyprland/language" = {
        format = "test {}";
        format-us = "EN";
        format-ru = "RU";
        keyboard-name = "gaming-keyboard";
        on-click = "hyprctl switchxkblayout gaming-keyboard next";
      };
    };
  };
}
