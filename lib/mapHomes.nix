{
  inputs,
  outputs,
  modules,
  nixpkgs,
  home-manager,
  path,
  ...
}: let
  readSysArch = builtins.attrNames (builtins.readDir path);
  mach = builtins.map (x:
    builtins.mapAttrs (name: value:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${x};
        extraSpecialArgs = {inherit inputs outputs;};
        modules =
          modules
          ++ [
            (path + "/${x}" + "/${name}")
          ];
      })
    (builtins.readDir (path + "/${x}")))
  readSysArch;
in
  nixpkgs.lib.attrsets.mergeAttrsList mach
