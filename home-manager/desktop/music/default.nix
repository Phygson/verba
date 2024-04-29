{
  lib,
  config,
  pkgs,
  ...
}: {
  services.mpd = {
    enable = true;
    musicDirectory = /data/Music;
    extraConfig = ''
      auto_update "yes"
      restore_paused "yes"
    '';
  };
  home.packages = with pkgs; [mpc-cli picard];

  imports = [
    ./ncmpcpp.nix
  ];
}
