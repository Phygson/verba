{
  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "x86_64-linux"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;

    z-lib = nixpkgs.lib.concatMapAttrs (name: value: {
      ${(nixpkgs.lib.strings.removeSuffix ".nix" name)} = import (./lib + "/${name}");
    }) (builtins.readDir ./lib);

    _mixedModules = z-lib.mapModules ./modules/mixed;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = z-lib.mapOverlays inputs ./overlays;

    nixosModules = nixpkgs.lib.mergeAttrs (z-lib.mapModules ./modules/nixos) _mixedModules;
    homeManagerModules = nixpkgs.lib.mergeAttrs (z-lib.mapModules ./modules/home) _mixedModules;

    nixosConfigurations = z-lib.mapSystems {
      inherit inputs outputs nixpkgs;
      modules = z-lib.attrValuesFlatten nixpkgs.lib outputs.nixosModules;
      path = ./systems;
    };

    homeConfigurations = z-lib.mapHomes {
      inherit inputs outputs nixpkgs home-manager;
      modules =
        (z-lib.attrValuesFlatten nixpkgs.lib outputs.homeManagerModules)
        ++ [
          inputs.nixvim.homeManagerModules.nixvim
          inputs.nix-index-database.hmModules.nix-index
        ];
      path = ./homes;
    };
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nixvim
    nixvim.url = "github:nix-community/nixvim/nixos-23.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # nix-index-database
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # nh
    nh.url = "github:viperML/nh";
    nh.inputs.nixpkgs.follows = "nixpkgs";
  };
}
