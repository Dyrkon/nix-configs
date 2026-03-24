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

    targets.darwin.copyApps.enableChecks = false;
    targets.darwin.copyApps.enable = true;
    targets.darwin.linkApps.enable = false;
  };
}
