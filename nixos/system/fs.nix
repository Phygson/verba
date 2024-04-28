{
  lib,
  config,
  pkgs,
  ...
}: {
  boot.supportedFilesystems = ["ntfs"];
  fileSystems = {
    "/".options = ["compress=zstd" "noatime"];
    "/home".options = ["compress=zstd" "noatime"];
    "/nix".options = ["compress=zstd" "noatime"];
    "/data" = {
      label = "Data";
      fsType = "ntfs-3g";
      options = ["rw"];
    };
  };
}
