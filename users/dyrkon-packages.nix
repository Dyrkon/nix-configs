{
  config,
  pkgs,
  lib,
  ...
}: 
{
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
    # jetbrains.clion
    # (jetbrains.plugins.addPlugins jetbrains.pycharm-professional ["github-copilot"])
    (jetbrains.plugins.addPlugins jetbrains.rider ["github-copilot"])

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
    fastfetch
    xplayer
    bitwarden
    lutris
    easyeffects
    obs-studio
    ulauncher

    # Wine
    wine
    wine64
    wineWowPackages.stable
    winetricks
    wineWowPackages.staging
    protontricks

    # VR
    # immersed-vr

    # Simracing
    oversteer
  ];
}
