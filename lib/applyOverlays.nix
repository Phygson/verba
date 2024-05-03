{_overlays, ...}: {
  nixpkgs.overlays = builtins.attrValues _overlays;
}
