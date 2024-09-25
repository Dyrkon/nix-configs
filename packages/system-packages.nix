{pkgs, ...}: {
  imports = [
    ./fish.nix
    ./steam.nix
    ./zerotier.nix
    ./git.nix
  ];

  environment.systemPackages = with pkgs; [
    # Networking
    wireguard-tools
    wget
    curl
    iperf
    sshfs
    dig

    vim
    htop
    fzf
    grc
    piper
    libratbag
    filelight
    gparted
    docker
    podman
    python3
    anydesk
    zip
    unzip
    virt-manager
    vlc
    lshw
    exfatprogs
    linuxKernel.packages.linux_xanmod_latest.xone
    steam-run
    alejandra

    # Development
    jetbrains.gateway
    attic-client
    #git-lfs

    # Image and video editing
    darktable
    davinci-resolve

    # VR
    immersed-vr
  ];
}
