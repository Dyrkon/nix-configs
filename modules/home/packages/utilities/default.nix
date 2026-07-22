{pkgs, ...}: {
  home.packages = with pkgs; [
    htop
    fastfetch
    rectangle
    wireshark
    zstd
    oh-my-fish
    localsend
  ];
}
