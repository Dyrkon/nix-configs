{pkgs, ...}: {
  home.packages = with pkgs; [
    jetbrains.pycharm
    jetbrains.rider
    jetbrains.clion
  ];
}
