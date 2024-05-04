{
  inputs,
  outputs,
  modules,
  nixpkgs,
  path,
  ...
}: let
  readSysArch = builtins.attrNames (builtins.readDir path);
  mach = builtins.map (x:
    builtins.mapAttrs (name: value:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        system = x;
        modules =
          [({outputs, ...}: {nixpkgs.overlays = builtins.attrValues outputs.overlays;})]
          ++ modules
          ++ [
            (path + "/${x}" + "/${name}")
          ];
      })
    (builtins.readDir (path + "/${x}")))
  readSysArch;
in
  nixpkgs.lib.attrsets.mergeAttrsList mach
