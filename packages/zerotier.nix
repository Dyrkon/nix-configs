{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # Zerotier VPN
  services.zerotierone = {
    enable = true; # change to true to enable VPN
    joinNetworks = [
      "9f77fc393e21b526"
    ];
  };
}
