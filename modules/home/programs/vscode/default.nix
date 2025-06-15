{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) mkOpt;
  cfg = config.${namespace}.programs.vscode;
in {
  options.${namespace}.programs.vscode = {
    enable = lib.mkEnableOption "VS Code";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;

      profiles.default.extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-dotnettools.csharp
        bbenoist.nix
        github.copilot
      ];

      profiles.default.userSettings = let
        font = "'JetbrainsMono Nerd Font', 'monospace', monospace";
      in {
        enableUpdateCheck = false;
        update.mode = "none";
        window.zoomLevel = 0;
        terminal.integrated.profiles.osx.fish = {
          path = "${pkgs.fish}/bin/fish";
          args = ["-l"];
        };
        terminal.integrated.defaultProfile.osx = "fish";
        editor = {
          fontFamily = font;
          fontLigatures = true;
          inlineSuggest.enabled = true;
          bracketPairColorization.enabled = true;
          formatOnSave = true;
        };
        jupyter.alwaysTrustNotebooks = true;
        latex-workshop.view.pdf.viewer = "tab";
        cmake.configureOnOpen = false;
        python.formatting.provider = "black";
        window.menuBarVisibility = "toggle";
        files.exclude = {
          "**/.git" = true;
          "**/.svn" = true;
          "**/.hg" = true;
          "**/CVS" = true;
          "**/.DS_Store" = true;
          "**/Thumbs.db" = true;
        };
      };
    };
  };
}
