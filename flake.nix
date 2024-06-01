{
  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs:
    import ./lib/mkFlake.nix {
      inherit inputs nixpkgs home-manager;
      outputs = self.outputs;
      extra-hm-modules = [
        inputs.nixvim.homeManagerModules.nixvim
        inputs.nix-index-database.hmModules.nix-index
      ];
    };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nixvim
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # nix-index-database
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # nh
    nh.url = "github:viperML/nh";
    nh.inputs.nixpkgs.follows = "nixpkgs";
  };
}
