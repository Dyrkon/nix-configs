{
  pkgs,
  username,
  secretsFile,
  ...
}: {
  imports = [./hardware.nix];

  networking.hostName = "nixos";
  networking.interfaces.enp5s0.wakeOnLan.enable = true;

  programs.steam.enable = true;
  programs.firefox.enable = true;

  sops = {
    defaultSopsFile = secretsFile;
    age.sshKeyPaths = ["/home/${username}/.ssh/id_ed25519"];
  };

  users.users.${username} = {
    isNormalUser = true;
    uid = 1027;
    group = "users";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "docker"
      "podman"
      "disk"
      "input"
      "kvm"
      "libvirtd"
      "qemu-libvirtd"
    ];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = ["electron-36.9.5"];

  nix.settings = {
    cores = 8;
    max-jobs = 4;
  };

  system.stateVersion = "25.11";
}
