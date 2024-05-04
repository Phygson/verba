{path}: let
  readData = builtins.readDir path;
  readSet = builtins.mapAttrs (name: value: path + "/${name}") readData;
in
  builtins.mapAttrs (name: value:
    if (builtins.readDir value ? "default.nix")
    then import value
    else import ./mapModules.nix {path = value;})
  readSet
