{
  config,
  pkgs,
  ...
}: {
  services.mpd = {
    enable = true;
    musicDirectory = config.home.homeDirectory + "/Music";
    extraConfig = ''
      auto_update "yes"
      restore_paused "yes"
      audio_output {
        type "pipewire"
        name "My PipeWire Output"
      }
    '';
  };
  home.packages = with pkgs; [mpc-cli picard];

  imports = [
    ./ncmpcpp.nix
  ];
}
