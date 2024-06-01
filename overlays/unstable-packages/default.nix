# This file defines overlays
{inputs, ...}: final: _prev: {
  unstable = import inputs.nixpkgs-unstable {
    system = final.system;
    config.allowUnfree = true;
  };
  master = import inputs.nixpkgs-master {
    system = final.system;
    config.allowUnfree = true;
  };
}
