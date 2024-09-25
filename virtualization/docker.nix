{ config, pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    # enableNvidia = true;
    storageDriver = "btrfs";
  };
}