{...}: {
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
}
