{pkgs, ...}: {
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.openssh.enable = true;
  services.openssh.settings.X11Forwarding = true;

  networking.firewall.allowedTCPPorts = [80 443 21000 21013];
  # networking.firewall.allowedUDPPorts = [ 9993 ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
