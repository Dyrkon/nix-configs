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
    nix = enabled;
    programs.fish.enable = true;
    user.enable = true;
  };

  environment.systemPath = ["/opt/homebrew/bin"];

  networking = {
    computerName = "Matejs MacBook Pro";
    hostName = "macpro";
    localHostName = "macpro";

    knownNetworkServices = [];
    wakeOnLan = enabled;
  };

  nix.settings = {
    cores = 8;
    max-jobs = 6;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.${cfg.name} = {
    openssh = {
      authorizedKeys.keys = [
      ];
    };
  };

  system = {
    stateVersion = 6;
  };
}
