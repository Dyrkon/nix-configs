{username, ...}: {
  environment.systemPath = ["/opt/homebrew/bin"];

  networking = {
    computerName = "Matejs MacBook Pro";
    hostName = "macpro";
    localHostName = "macpro";
    knownNetworkServices = [];
  };

  nix.settings = {
    cores = 8;
    max-jobs = 6;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.${username} = {
    openssh.authorizedKeys.keys = [];
  };

  system.stateVersion = 6;
}
