{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    lib = inputs.nixpkgs.lib;
    system = "x86_64-linux";  # Specify your system here
    nixpkgs-patched = (import nixpkgs system).applyPatches {
      name = "nixpkgs-patched-rider-dev-server";
      src = nixpkgs;
      patches = [
        ./patches/rider-dev-server.patch
      ];
    };
  in {
    nixosConfigurations.facis-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs system; };
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
        ./settings/audio.nix
        ./settings/networking.nix
        ./settings/package-settings.nix
        ./settings/peripherals.nix
        ./packages/system-packages.nix
        ./users/dyrkon.nix
        ./virtualization/vm.nix
        ./virtualization/docker.nix
      ];
    };
  };
}
