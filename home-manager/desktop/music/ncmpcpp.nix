{pkgs, ...}: {
  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.overrideAttrs (finalAttrs: previousAttrs: {
      patches = [./ncmpcppFixGenius.patch];
    });
    settings = {
      lyrics_fetchers = "genius";
      follow_now_playing_lyrics = "yes";
      fetch_lyrics_for_current_song_in_background = "yes";
      media_library_primary_tag = "album_artist";
      startup_screen = "media_library";
    };
  };
  home.shellAliases.ncmp = "ncmpcpp";
}
