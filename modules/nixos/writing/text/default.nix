{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    obsidian
    libreoffice-qt
    pandoc
  ];
}
