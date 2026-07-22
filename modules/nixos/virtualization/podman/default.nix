{pkgs, ...}: {
  boot.enableContainers = false;

  environment.systemPackages = with pkgs; [
    podman-compose
    podman-desktop
  ];

  virtualisation = {
    podman = {
      autoPrune = {
        enable = true;
        flags = ["--all"];
        dates = "weekly";
      };

      defaultNetwork.settings.dns_enabled = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };
}
