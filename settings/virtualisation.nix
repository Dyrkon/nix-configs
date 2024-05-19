{pkgs, ...}: {
  # Add virt-manager virtualisation
  virtualisation.libvirtd.enable = true; # Need to add virt-manager package
  programs.dconf.enable = true;

  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
    storageDriver = "btrfs";
  };
}
