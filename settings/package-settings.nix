{pkgs, inputs, ...}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
