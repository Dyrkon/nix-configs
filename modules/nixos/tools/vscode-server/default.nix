{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.services.vscode-server;
in {
  options.${namespace}.services.vscode-server = {
    enable = mkBoolOpt false "Whether to enable VS Code Server compatibility support for NixOS Remote SSH.";

    enableFHS = mkBoolOpt false "Whether to enable an FHS environment for VS Code extensions with bundled binaries.";
  };

  config = lib.mkIf cfg.enable {
    services.vscode-server = {
      enable = true;
      enableFHS = cfg.enableFHS;

      # Optional, but handy if you use stable + insiders:
      installPath = [
        "$HOME/.vscode-server"
        "$HOME/.vscode-server-insiders"
      ];

      # Optional runtime deps for extensions that need them.
      extraRuntimeDependencies = with pkgs; [
        curl
        git
      ];
    };
  };
}
