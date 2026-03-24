{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [
    ./hardware.nix
  ];

  dyrkonix = {
    nix = enabled;

    suites = {
      common = {
        enable = true;
      };

      gaming = {
        enable = true;
      };

      creative = {
        enable = true;
      };

      communication = {
        enable = true;
      };

      office = {
        enable = true;
      };

      browsing = {
        enable = true;
      };

      development = {
        enable = true;
      };

      data-analysis = {
        enable = true;
      };
    };

    services = {
      vscode-server = {
        enable = true;
        enableFHS = true;
      };
    };

    security = {
      sops = {
        enable = true;
        defaultSopsFile = lib.snowfall.fs.get-file "secrets/secrets.yaml";
        sshKeyPaths = ["${config.users.users.${config.${namespace}.user.name}.home}/.ssh/id_ed25519"];
      };

      pxe-config = {
        enable = true;
      };
    };
  };

  nix.settings = {
    cores = 8;
    max-jobs = 4;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
