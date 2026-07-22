{lib, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wireshark-qt
    cifs-utils
  ];

  networking.networkmanager.enable = true;

  services.openssh.enable = true;
  services.openssh.settings.X11Forwarding = true;
  services.openssh.extraConfig = "AllowTcpForwarding yes";

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

  networking.nameservers = ["1.1.1.1" "8.8.8.8" "192.168.88.1"];

  networking.firewall.extraCommands = "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns";

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
}
