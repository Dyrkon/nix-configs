{
  config,
  pkgs,
  ...
}: let
  packagesModule = import ./dyrkon-packages.nix {inherit config pkgs;};
in {
  nixpkgs.config.permittedInsecurePackages = packagesModule.outdated ++ [];
  nixpkgs.config.allowUnfree = true;

  users.users.dyrkon = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "matej";
    extraGroups = ["networkmanager" "wheel" "docker" "libvirtd"];
    packages = with pkgs; packagesModule.user-packages ++ [];
  };
}
