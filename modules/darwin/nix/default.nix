{
  config,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.nix;
in {
  imports = [(lib.snowfall.fs.get-file "modules/shared/nix/default.nix")];

  config = lib.mkIf cfg.enable {
    # Nix-Darwin config options
    # Check corresponding shared imported module
    nix = {
      # Options that aren't supported through nix-darwin
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

      # NOTE: not sure if i saw any benefits changing this
      # daemonProcessType = "Adaptive";

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

      # The homelab server (HPE DL380 Gen10, 40 threads / 128 GB) as an
      # x86_64-linux builder. Declared here rather than in the shared module
      # because the key below only exists on this host.
      #
      # Server side: modules/remote-builder.nix in ~/Code/nix/server-configuration
      # (homelab.remoteBuilder - creates the nix-builder account, authorizes the
      # public half of sshKey and makes the account a nix trusted-user).
      #
      # sshKey is read by the nix *daemon*, which runs as root, so it lives in
      # /etc/nix rather than any user's ~/.ssh. Create it once with:
      #   sudo ssh-keygen -t ed25519 -N "" -C "root@macpro nix-daemon" \
      #     -f /etc/nix/remote-builder-key
      # Do not reuse /etc/nix/builder_ed25519 - that is nixpkgs' well-known
      # darwin-builder keypair and its private half is public.
      #
      # This complements nix.linux-builder below rather than replacing it: the
      # local VM is a *native* aarch64-linux builder, which this x86 box can
      # only match through qemu. Nix picks per-system, so both stay useful.
      buildMachines = [
        {
          hostName = "192.168.1.192";
          systems = ["x86_64-linux"];
          protocol = "ssh-ng";
          sshUser = "nix-builder";
          sshKey = "/etc/nix/remote-builder-key";
          # Base64 of the server's /etc/ssh/ssh_host_ed25519_key.pub. Pins the
          # host without an entry in root's known_hosts - otherwise the first
          # dispatched build dies on an unanswerable confirmation prompt.
          publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUhXQVdkMjJoUWN6ZkRjeElTUFRpS2Vxd21wZ2hQUkJ1VXljSDRwT1dPUEMgcm9vdEBzZXJ2ZXIK";
          # 40 threads, and the resident workloads (Home Assistant, the VMs,
          # two CI runners) leave most of them idle - so take 24.
          maxJobs = 24;
          # Above bigpc's 10 in the shared module: same systems, and this one
          # is actually always on.
          speedFactor = 15;
          supportedFeatures = ["big-parallel" "benchmark" "kvm" "nixos-test"];
        }
      ];

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
  };
}
