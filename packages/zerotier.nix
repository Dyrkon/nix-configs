{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # Zerotier VPN
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "9f77fc393e21b526"
    ];
    port = 9993;
  };
}
