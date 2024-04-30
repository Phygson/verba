{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.;
in {
  options. = {
    enable = mkEnableOption "sth";
  };

  config = mkIf cfg.enable {
    
  };
}