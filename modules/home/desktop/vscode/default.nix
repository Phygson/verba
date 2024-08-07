{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.verba.vscode;
in {
  options.verba.vscode = {
    enable = lib.mkEnableOption "Visual Studio Code";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium.fhsWithPackages (ps: [
        pkgs.nixd
      ]);
      mutableExtensionsDir = true;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        kamadorueda.alejandra
        llvm-vs-code-extensions.vscode-clangd
        mkhl.direnv
        jdinhlife.gruvbox
        haskell.haskell
        justusadam.language-haskell
      ];
      userSettings = {
        "editor.fontFamily" = "'FiraCode Nerd Font Mono'";
        "editor.fontLigatures" = true;
        "terminal.integrated.shellIntegration.enabled" = false;
        "terminal.integrated.defaultProfile.linux" = "fish";
        "terminal.integrated.cursorStyle" = "line";
        "terminal.explorerKind" = "integrated";
        "terminal.integrated.cursorBlinking" = true;
        "terminal.integrated.shellIntegration.decorationsEnabled" = "never";
        "workbench.colorTheme" = "Default Dark Modern";
        "[cpp]" = {
          "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
        };
        "editor.formatOnSave" = true;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = ["nix fmt"];
            };
            "options" = {
              "nixos" = {
                "expr" = "(builtins.getFlake \"/etc/nixos/nix-flake\").nixosConfigurations.grob.options";
              };
              "home-manager" = {
                "expr" = "(builtins.getFlake \"/etc/nixos/nix-flake\").homeConfigurations.\"phygson@grob\".options";
              };
            };
          };
        };
      };
    };
  };
}
