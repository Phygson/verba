# This file defines overlays
{inputs, ...}: final: _prev: {
  master = import inputs.nixpkgs-master {
    system = final.system;
    config.allowUnfree = true;
  };
}
