{ lib, config, pkgs, ... }: 

{
  services.mpd = {
    enable = true;
    musicDirectory = /data/Music;
  };
  home.packages = with pkgs; [ mpc-cli ];

  imports = [
    ./ncmpcpp.nix
  ];
}
