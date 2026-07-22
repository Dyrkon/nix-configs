{pkgs, ...}: {
  home.packages = with pkgs; [
    bitwarden-desktop
    gparted
    kdePackages.ark
    kdePackages.gwenview
    realvnc-vnc-viewer
  ];

  home.username = "dyrkon";
  home.homeDirectory = "/home/dyrkon";
  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
