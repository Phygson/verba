{
  boot.supportedFilesystems = ["btrfs" "ntfs"];
  fileSystems = {
    "/".options = ["compress=zstd" "noatime" "space_cache=v2" "discard=async"];
    "/home".options = ["compress=zstd" "noatime" "space_cache=v2" "discard=async"];
    "/nix".options = ["compress=zstd" "noatime" "space_cache=v2" "discard=async"];
    "/data" = {
      device = "/dev/disk/by-uuid/D2E23D45E23D2EDB";
      fsType = "ntfs-3g";
      options = ["rw" "uid=1000" "nofail" "x-gvfs-show"];
    };
    "/SteamLibrary".options = ["compress=zstd" "noatime" "space_cache=v2" "discard=async" "nofail" "x-gvfs-show"];
  };
}
