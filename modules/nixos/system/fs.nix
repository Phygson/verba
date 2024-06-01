{
  boot.supportedFilesystems = ["btrfs" "ntfs"];
  fileSystems = {
    "/".options = ["compress=zstd" "noatime"];
    "/home".options = ["compress=zstd" "noatime"];
    "/nix".options = ["compress=zstd" "noatime"];
    "/data" = {
      device = "/dev/disk/by-uuid/D2E23D45E23D2EDB";
      fsType = "ntfs-3g";
      options = ["rw" "uid=1000" "nofail" "x-gvfs-show"];
    };
    "/shared" = {
      device = "/dev/disk/by-uuid/FA24F53724F4F789";
      fsType = "ntfs-3g";
      options = ["rw" "uid=1000" "nofail" "x-gvfs-show"];
    };
  };
}
