{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wine
    wine64
    wineWowPackages.stable
    winetricks
    wineWowPackages.staging
    xwayland
    protontricks
  ];
}
