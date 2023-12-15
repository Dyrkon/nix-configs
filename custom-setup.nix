# Custom nix setup file
{ config, lib, pkgs, modulesPath, ... }:

{

  # Wayland config script
  systemd.user.services.wayland-config = {
    script = ''
    xrandr --output DP-1 --primary
    '';
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };

  # Zerotier VPN
  services.zerotierone = {
    enable = true; # change to true to enable VPN
    joinNetworks = ["0cccb752f79256ec"
                    "9f77fc393e21b526"];
  };

  # Enable BT
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Noise-torch noise supression
  programs.noisetorch.enable = true;

  # Add virt-manager virtualisation
  virtualisation.libvirtd.enable = true; # Need to add virt-manager package
  programs.dconf.enable = true;
  users.users.dyrkon.extraGroups = [ "libvirtd" ];

  # Add Virtualbox
  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxusers.members = [ "dyrkon" ];
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # virtualisation.virtualbox.guest.x11 = true;
}
