# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    ./hardware-configuration.nix
  ];

  swapDevices = [{device = "/swap/swapfile";}];

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
  programs.hyprland.xwayland.enable = true;
  programs.hyprland.portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;

  environment.sessionVariables = {
    FLAKE = "/etc/nixos/";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  environment.plasma5.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
  ];
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

  programs.steam.enable = true;
  programs.gamemode.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;

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

  z.util = {
    enable = true;
    package-nh = inputs.nh.packages.x86_64-linux.default;
  };

  programs.fish.enable = true;

  security.pam.services.gtklock = {};
  environment.systemPackages = with pkgs; [
    neovim
    pavucontrol
    unar
    p7zip
    alejandra
    killall
    btop
    btrfs-assistant
    polkit_gnome
    git
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
