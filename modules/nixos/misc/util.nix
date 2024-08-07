{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.verba.util;
  vh = pkgs.writeShellScriptBin "vh" ''
    nh home switch
  '';
  vs = pkgs.writeShellScriptBin "vs" ''
    nh os switch
  '';
  va = pkgs.writeShellScriptBin "va" ''
    nh os switch && nh home switch
  '';
  vu = pkgs.writeShellScriptBin "vu" ''
    nix flake update --commit-lock-file $FLAKE
  '';
in {
  options.verba.util = {
    enable = lib.mkEnableOption "v util";
    package-nh = lib.mkOption {
      type = lib.types.package;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.shellAliases.v = "cd $FLAKE";
    environment.systemPackages = [vh vs va vu cfg.package-nh];
  };
}
