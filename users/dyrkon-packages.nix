{ config, pkgs, ... }:

{
  outdated = [ "electron-25.9.0" ];

  user-packages = with pkgs; [
    firefox
    jetbrains-toolbox
    vscode
    obsidian
    discord
    element-desktop
    signal-desktop
    wireshark-qt

    # Jetbrains IDEs
    (jetbrains.plugins.addPlugins jetbrains.pycharm-professional [ "github-copilot" ])
    (jetbrains.plugins.addPlugins jetbrains.rider [ "github-copilot" ])
    jetbrains.clion
    jetbrains.datagrip

    spotify
    libsForQt5.kdeconnect-kde
    brave
    google-chrome
    krita
    podman-desktop
    wacomtablet
    libwacom
    xf86_input_wacom
    usbutils
    audacity
    libreoffice-qt
    cudatoolkit
    pandoc
    ffmpeg
    rpi-imager
    blender
    isoimagewriter
    neofetch
    darktable
    xplayer
    bitwarden
    lutris
    
    # Wine
    wine
    wine64
    wineWowPackages.stable
    winetricks
    wineWowPackages.staging
  ];
}