{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.z.util;
  zh = pkgs.writeShellScriptBin "zh" ''
    nh home switch
  '';
  zs = pkgs.writeShellScriptBin "zs" ''
    nh os switch
  '';
  za = pkgs.writeShellScriptBin "za" ''
    nh os switch && nh home switch
  '';
  zu = pkgs.writeShellScriptBin "zu" ''
    nix flake update --commit-lock-file $FLAKE
  '';
in {
  options.z.util = {
    enable = lib.mkEnableOption "z util";
    package-nh = lib.mkOption {
      type = lib.types.package;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.shellAliases.z = "cd $FLAKE";
    environment.systemPackages = [zh zs za zu cfg.package-nh];
  };
}
