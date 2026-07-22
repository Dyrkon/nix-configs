{...}: {
  hardware.nvidia-container-toolkit.enable = true;

  virtualisation.docker = {
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    enable = true;
    storageDriver = "btrfs";
  };
}
