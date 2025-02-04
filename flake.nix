{
  description = "Dyrkon's Nix configuration flake";

  inputs = {
    # NixPkgs (nixos-unstable)
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Snowfall Flake
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # macOS Support (master)
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
    };
  };

  outputs = {self, ...} @ inputs: let
    lib = inputs.snowfall-lib.mkLib {
      # You must pass in both your flake's inputs and the root directory of
      # your flake.
      inherit inputs;
      src = ./.;

      snowfall = {
        meta = {
          name = "dyrkonix";
          title = "DyrkoNix";
        };

        namespace = "dyrkonix";
      };
    };
  in
    lib.mkFlake {
      channels-config = {
        # allowBroken = true;
        allowUnfree = true;

        permittedInsecurePackages = [];
      };

      systems = {
        modules = {
          darwin = with inputs; [sops-nix.darwinModules.sops];
          nixos = with inputs; [
            sops-nix.nixosModules.sops
          ];
        };
      };

      homes.modules = with inputs; [
        plasma-manager.homeManagerModules.plasma-manager
        sops-nix.homeManagerModules.sops
      ];

      outputs-builder = channels: {
        formatter = channels.nixpkgs.alejandra;
      };
    };
}
