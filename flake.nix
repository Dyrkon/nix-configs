{
  description = "A simple NixOS flake";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "path:/home/dyrkon/Code/nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.facis-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
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