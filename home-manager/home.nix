{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    outputs.homeManagerModules.rebuild

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "phygson";
    homeDirectory = "/home/phygson";
  };
  home.packages = with pkgs; [ vscodium-fhs ];

  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;
    plugins = {
      nix.enable = true;
    };
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.gh.enable = true;
  programs.firefox.enable = true;

  programs.bash = {
    enable = true;
    shellAliases.cdnix = "cd /etc/nixos/nix-flake";
  };
  programs.fzf.enable = true;
  programs.fish = {
    enable = true;
    shellAliases.cdnix = "cd /etc/nixos/nix-flake";
    plugins = with pkgs.fishPlugins; [ 
      {
        name = "pure";
        src = pure.src;
      }

      {
        name = "fzf.fish";
        src = fzf-fish.src;
      }
    ];
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    settings.shell = "fish";
    theme = "Gruvbox Dark";
  };

  z.rebuild.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.11";
}
