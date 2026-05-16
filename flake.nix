{
  description = "Babicka ThinkPad E530";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, deploy-rs }: {
    nixosConfigurations.babicka = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
      ];
    };

    deploy.nodes.babicka = {
        hostname = "192.168.0.183";
        profiles.system = {
            user = "root";
            path = (import github:serokell/deploy-rs { 
                system = "x86_64-linux";
            }).lib.activate.nixos self.nixosConfigurations.babicka;
        };
    };
  };
}