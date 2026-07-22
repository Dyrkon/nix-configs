{config, lib, ...}: {
  nix = {
    extraOptions = ''
      # bail early on missing cache hits
      connect-timeout = 10
      keep-going = true
    '';

    gc = {
      interval = [
        {
          Hour = 3;
          Minute = 15;
          Weekday = 1;
        }
      ];
    };

    # Optimize nix store after cleaning
    optimise.interval = lib.lists.forEach config.nix.gc.interval (e: {
      inherit (e) Minute Weekday;
      Hour = e.Hour + 1;
    });

    settings = {
      build-users-group = "nixbld";

      extra-sandbox-paths = [
        "/System/Library/Frameworks"
        "/System/Library/PrivateFrameworks"
        "/usr/lib"

        "/private/tmp"
        "/private/var/tmp"
        "/usr/bin/env"
      ];

      # Frequent issues with networking failures on darwin
      # limit number to see if it helps
      http-connections = lib.mkForce 25;

      # FIXME: upstream bug needs to be resolved before fully enabling
      # https://github.com/NixOS/nix/issues/12698
      sandbox = lib.mkForce "relaxed";
    };

    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 4;
      config = {
        virtualisation = {
          darwin-builder = {
            diskSize = 40 * 1024;
            memorySize = 8 * 1024;
          };
          cores = 6;
        };
      };
    };
  };
}
