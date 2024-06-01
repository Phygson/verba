inputs: path: let
  readData = builtins.readDir path;
in
  builtins.mapAttrs (name: value: import (path + "/${name}") {inherit inputs;}) readData
