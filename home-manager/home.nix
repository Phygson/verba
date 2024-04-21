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

  wayland.windowManager.hyprland = {
    enable = true;
    # enableNvidiaPatches = true;
    extraConfig = ''
      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = WLR_NO_HARDWARE_CURSORS,1
    '';
    settings = {
      "$mod" = "SUPER";
      bind = 
        [
          "$mod, B, exec, firefox"
          "$mod, RETURN, exec, kitty"
          "$mod, W, killactive"
          "$mod, L, exec, gtklock -m /run/current-system/sw/lib/gtklock/powerbar-module.so -m /run/current-system/sw/lib/gtklock/playerctl-module.so -m /run/current-system/sw/lib/gtklock/userinfo-module.so"
          "SUPERALT, Q, exit"
        ];
      bindm = 
        [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      input = {
        "kb_layout" = "us,ru";
        "kb_options" = "grp:alt_shift_toggle";
        "follow_mouse" = "1";
      };
      animations = {
        "enabled" = "yes";
        "bezier" = "myBezier, 0.05, 0.9, 0.1, 1.05";

        "animation" = [ 
          "windows, 1, 3, myBezier"
          "windowsOut, 1, 3, default, popin 80%"
          "border, 1, 4, default"
          "fade, 1, 3, default"
          "workspaces, 1, 2, default"
        ];
      };
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
  #programs.command-not-found.enable = true;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
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
