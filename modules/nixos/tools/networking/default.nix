{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wireguard-tools
    wget
    curl
    iperf
    sshfs
    dig
    filezilla
  ];
}
