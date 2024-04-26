{ lib, config, pkgs, ... }: 

{
  services.mpd = {
    enable = true;
    musicDirectory = /data/Music;
  };
  programs.ncmpcpp.enable = true;
  home.packages = with pkgs; [ mpc-cli ];
}