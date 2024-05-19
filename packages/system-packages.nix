{pkgs, ...}: {
  imports = [
    ./fish.nix
    ./steam.nix
    ./zerotier.nix
    ./git.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    curl
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
    piper
    libratbag
    filelight
    gparted
    docker
    podman
    python3
    iperf
    anydesk
    zip
    unzip
    virt-manager
    vlc
    sshfs
    dig
    lshw
    exfatprogs
    linuxKernel.packages.linux_xanmod_latest.xone
    steam-run
    alejandra

    darktable
    davinci-resolve

    immersed-vr
  ];
}
