{pkgs, ...}: {
  home.packages = with pkgs; [
    curl
    podman
    qemu
  ];
}
