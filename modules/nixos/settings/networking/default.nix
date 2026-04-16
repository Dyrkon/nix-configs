{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the module system.
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.hardware.networking;
in {
  options.${namespace}.hardware.networking = {
    enable = mkBoolOpt false "Whether or not to enable support for networking.";
  };

  config = mkIf cfg.enable {
    dyrkonix = {
      user = {
        extraGroups = [
          "network"
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      wireshark-qt
      cifs-utils
    ];

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    # Allow Wake-on-LAN
    networking.interfaces.enp5s0.wakeOnLan.enable = true;

    networking.hostName = lib.mkForce "bigpc"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    services.openssh.enable = true;
    services.openssh.settings.X11Forwarding = true;
    services.openssh.extraConfig = ''AllowTcpForwarding yes'';

    # NFS client
    # fileSystems."/home/${config.${namespace}.user.name}/Nas" = {
    #   device = "192.168.1.87:/volume1/mbackup";
    #   fsType = "nfs";
    #   options = ["x-systemd.automount" "noauto" "nofail"];
    # };

    systemd.tmpfiles.rules = [
      "d /mnt/share 0775 root users - -"
    ];

    systemd.mounts = [
      {
        what = "//192.168.88.170/matej";
        where = "/mnt/share";
        type = "cifs";
        wants = ["network-online.target"];
        after = ["network-online.target"];

        mountConfig = {
          TimeoutSec = "5s";
          Options = lib.concatStringsSep "," [
            "credentials=/etc/nixos/smb-secrets"
            "vers=3.0"
            "uid=1027"
            "gid=100"
            "forceuid"
            "forcegid"
            "file_mode=0660"
            "dir_mode=0770"
            "noperm"
            "nofail"
          ];
        };
      }
    ];

    systemd.automounts = [
      {
        where = "/mnt/share";
        wantedBy = ["multi-user.target"];
        automountConfig = {
          TimeoutIdleSec = "60s";
        };
      }
    ];

    networking.nameservers = [ "1.1.1.1" "8.8.8.8" "192.168.88.1" ];

    networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';

    networking.firewall.allowedTCPPorts = [80 443 21000 21013 64172 2049];
    networking.firewall.allowedUDPPorts = [64172 67 69 4011 9993 8001 8000];
    networking.firewall.allowedTCPPortRanges = [
      {
        from = 5000;
        to = 9000;
      }
    ];
    networking.firewall.allowedUDPPortRanges = [
      {
        from = 5000;
        to = 9000;
      }
    ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
  };
}
