# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    ./hardware-configuration.nix

    ./system/fs.nix
    ./system/nvidia.nix
    ./system/sound.nix
    ./system/boot.nix
  ];

  nixpkgs = {
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
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  networking.hostName = "grob";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    # LC_TIME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
  };
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  programs.hyprland.enable = true;
  programs.hyprland.package = pkgs.unstable.hyprland;
  programs.hyprland.portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;

  environment.sessionVariables = {
    FLAKE = "/etc/nixos/nix-flake/";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.xkb.layout = "us,ru";
  services.xserver.xkb.options = "grp:alt_shift_toggle";

  security.polkit.enable = true;

  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
    };
  };

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [thunar-volman thunar-archive-plugin];

  users.groups.sysconfmaster = {};
  users.users = {
    phygson = {
      initialPassword = "int";
      isNormalUser = true;
      extraGroups = ["wheel" "sysconfmaster"];
    };
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  security.pam.services.gtklock = {};
  environment.systemPackages = with pkgs; [
    neovim
    pavucontrol
    unar
    p7zip
    alejandra
    inputs.nh.packages.x86_64-linux.default
    killall
    btop
    btrfs-assistant
    polkit_gnome
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
