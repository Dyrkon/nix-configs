{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # jetbrains.clion
    # jetbrains.pycharm-professional
    jetbrains.rider
    vscode
  ];
}
