{
  inputs,
  outputs,
  modules,
  lib,
  path,
  ...
}: let
  readSysArch = builtins.attrNames (builtins.readDir path);
  mach = builtins.map (x:
    builtins.mapAttrs (name: value:
      lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        system = x;
        modules =
          builtins.attrValues modules
          ++ [
            (path + "/${x}" + "/${name}")
          ];
      })
    (builtins.readDir (path + "/${x}")))
  readSysArch;
in
  lib.attrsets.mergeAttrsList mach
