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
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "x86_64-linux"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;

    z-lib = nixpkgs.lib.concatMapAttrs (name: value: {
      ${(nixpkgs.lib.strings.removeSuffix ".nix" name)} = import (./lib + "/${name}");
    }) (builtins.readDir ./lib);

    _overlays = z-lib.mapOverlays {
      path = ./overlays;
      inherit inputs;
    };

    _nixosModules = z-lib.mapModules ./modules/nixos;
    _homeManagerModules = z-lib.mapModules ./modules/home;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = _overlays;

    nixosModules = _nixosModules;
    homeManagerModules = _homeManagerModules;

    nixosConfigurations = {
      grob = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs _overlays;};
        modules =
          [
            ./lib/applyOverlays.nix
            ./systems/x86_64-linux/grob
          ]
          ++ builtins.attrValues _nixosModules;
      };
    };

    homeConfigurations = {
      "phygson@grob" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs _overlays;};
        modules =
          [
            ./lib/applyOverlays.nix
            (./. + "/homes/x86_64-linux/phygson@grob")
            inputs.nixvim.homeManagerModules.nixvim
            inputs.nix-index-database.hmModules.nix-index
          ]
          ++ (z-lib.attrValuesFlatten {
            attrSet = _homeManagerModules;
            lib = nixpkgs.lib;
          });
      };
    };
  };
}
