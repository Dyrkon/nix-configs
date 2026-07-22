{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    spotify
    easyeffects
    audacity
    rhythmbox
  ];
}
