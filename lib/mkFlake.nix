{
  inputs,
  outputs,
  nixpkgs,
  home-manager,
  extra-nixos-modules ? [],
  extra-hm-modules ? [],
  ...
}: let
  z-lib = nixpkgs.lib.concatMapAttrs (name: value: {
    ${(nixpkgs.lib.strings.removeSuffix ".nix" name)} = import (./. + "/${name}");
  }) (builtins.readDir ./.);

  _mixedModules = z-lib.mapModules ../modules/mixed;
in {
  overlays = z-lib.mapOverlays inputs ../overlays;

  nixosModules = nixpkgs.lib.mergeAttrs (z-lib.mapModules ../modules/nixos) _mixedModules;
  homeManagerModules = nixpkgs.lib.mergeAttrs (z-lib.mapModules ../modules/home) _mixedModules;

  nixosConfigurations = z-lib.mapSystems {
    inherit inputs outputs nixpkgs;
    modules =
      (z-lib.attrValuesFlatten nixpkgs.lib outputs.nixosModules)
      ++ extra-nixos-modules;
    path = ../systems;
  };

  homeConfigurations = z-lib.mapHomes {
    inherit inputs outputs nixpkgs home-manager;
    modules =
      (z-lib.attrValuesFlatten nixpkgs.lib outputs.homeManagerModules)
      ++ extra-hm-modules;
    path = ../homes;
  };
}
