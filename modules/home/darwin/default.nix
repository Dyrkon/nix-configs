{
  config,
  lib,
  namespace,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.${namespace}.spotlight-patch;
  inherit (inputs) home-manager;
in {
  options.${namespace}.spotlight-patch.enable =
    lib.mkEnableOption "Enable macOS Home Manager settings";

  config = lib.mkIf cfg.enable {
    targets.darwin.defaults = {
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.dock" = {
        autohide = true;
      };
    };

    home.activation.copyApplications = let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
    in
      home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
        baseDir="$HOME/Applications/Home Manager"
        if [ -d "$baseDir" ]; then
          $DRY_RUN_CMD rm -rf "$baseDir"
        fi
        mkdir -p "$baseDir"
        for appFile in ${apps}/Applications/*; do
          target="$baseDir/$(basename "$appFile")"
          $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
          $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
        done
      '';
  };
}
