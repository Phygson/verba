{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.z.rebuild;
  impl = pkgs.writeShellScriptBin "rebuild" ''
    #!/bin/bash
    if [[ $1 = "home" ]]
    then
      home-manager switch --flake /etc/nixos/nix-flake/
    fi
    if [[ $1 = "system" ]]
    then
      sudo nixos-rebuild switch --flake /etc/nixos/nix-flake/
    fi
    if [[ $1 = "all" ]]
    then
      rebuild system; rebuild home
    fi

  '';
in {
  options.z.rebuild = {
    enable = mkEnableOption "rebuild command";
  };

  config = mkIf cfg.enable {
    home.packages = [impl];
  };
}
