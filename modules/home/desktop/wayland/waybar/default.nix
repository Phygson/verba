{...}: {
  programs.waybar.enable = true;
  programs.waybar.style = ./style.css;
  imports = [./settings.nix];
}
