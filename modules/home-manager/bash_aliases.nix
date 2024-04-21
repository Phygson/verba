{ lib, pkgs, config, ...}:
with lib;
let
  cfg = config.z.bash_aliases;
in {
  options.z.bash_aliases = {
    enable = mkEnableOption "Bash Aliases";
    nixos = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.nixos  {
    programs.bash.shellAliases = {
      cdnc = "cd /etc/nixos/nix-flake/";
      nrbs = "sudo nixos-rebuild switch --flake /etc/nixos/nix-flake/";
      nrbh = "home-manager switch --flake /etc/nixos/nix-flake/";
      nrba = "nrbs; nrbh";
    };
  };
}
