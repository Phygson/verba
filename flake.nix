{
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

    _overlays = z-lib.mapOverlays inputs ./overlays;

    _nixosModules = z-lib.mapModules ./modules/nixos;
    _homeManagerModules = z-lib.mapModules ./modules/home;
    _mixedModules = z-lib.mapModules ./modules/mixed;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = _overlays;

    nixosModules = nixpkgs.lib.mergeAttrs _mixedModules _nixosModules;
    homeManagerModules = nixpkgs.lib.mergeAttrs _mixedModules _homeManagerModules;

    nixosConfigurations = import ./lib/mapSystems.nix {
      inherit inputs outputs;
      modules = outputs.nixosModules;
      lib = nixpkgs.lib;
      path = ./systems;
    };

    homeConfigurations = {
      "phygson@grob" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules =
          (z-lib.attrValuesFlatten nixpkgs.lib outputs.homeManagerModules)
          ++ [
            (./. + "/homes/x86_64-linux/phygson@grob")
            inputs.nixvim.homeManagerModules.nixvim
            inputs.nix-index-database.hmModules.nix-index
          ];
      };
    };
  };
}
