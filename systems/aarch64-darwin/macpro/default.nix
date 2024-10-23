{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.user;
in {
  dyrkonix = {
    archetypes = {
      # personal = enabled;
      # workstation = enabled;
    };

    suites = {
      # art = enabled;
      # common = enabled;
      # desktop = enabled;
      # development = enabled;
      # games = enabled;
      # music = enabled;
      # networking = enabled;
      # social = enabled;
      # video = enabled;
      # vm = enabled;
    };

    tools.homebrew.masEnable = true;
  };

  environment.systemPath = ["/opt/homebrew/bin"];

  networking = {
    computerName = "Matejs MacBook Pro";
    hostName = "macpro";
    localHostName = "macpro";

    knownNetworkServices = [
    ];
  };

  nix.settings = {
    cores = 8;
    max-jobs = 4;
  };

  security.pam.enableSudoTouchIdAuth = true;

  # virtualisation = {
  #   docker = {
  #     enable = true;
  #     autoPrune = {
  #       enable = true;
  #       dates = "weekly";
  #     };
  #   };
  #   libvirtd.enable = true;
  # };

  users.users.${cfg.name} = {
    openssh = {
      authorizedKeys.keys = [
      ];
    };
  };

  system.stateVersion = 4;
}
