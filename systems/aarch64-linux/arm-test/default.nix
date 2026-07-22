{
  pkgs,
  username,
  secretsFile,
  ...
}: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
            };
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  sops = {
    defaultSopsFile = secretsFile;
    age.sshKeyPaths = ["/home/${username}/.ssh/id_ed25519"];
  };

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel" "networkmanager"];
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    cores = 2;
    max-jobs = 2;
  };

  system.stateVersion = "25.11";
}
