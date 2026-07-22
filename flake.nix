{
  description = "Dyrkon's Nix configuration flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
    };

    nixpkgs-darwin = {
      url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
    };

    rider-pkgs = {
      url = "github:NixOS/nixpkgs/d98abf5cf5914e5e4e9d57205e3af55ca90ffc1d";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-darwin,
    home-manager,
    darwin,
    sops-nix,
    disko,
    vscode-server,
    plasma-manager,
    rider-pkgs,
    ...
  } @ inputs: let
    mkSpecialArgs = extra: {
      inherit inputs self;
      secretsFile = ./secrets/secrets.yaml;
    }
    // extra;

    # Modules included in all full NixOS configurations
    fullNixosModules = [
      ./modules/shared/nix
      ./modules/nixos/nix
      ./modules/nixos/settings/bluetooth
      ./modules/nixos/settings/sound
      ./modules/nixos/settings/localization
      ./modules/nixos/settings/wayland
      ./modules/nixos/settings/networking
      ./modules/nixos/settings/system-settings
      ./modules/nixos/terminal/shell/fish
      ./modules/nixos/tools/utilities
      ./modules/nixos/tools/networking
      ./modules/nixos/tools/remote-desktop
      ./modules/nixos/security/pxe-setup
      ./modules/nixos/services/general
      ./modules/nixos/communication
      ./modules/nixos/writing/text
      ./modules/nixos/writing/development
      ./modules/nixos/browsers/chromium
      ./modules/nixos/virtualization/docker
      ./modules/nixos/virtualization/podman
      ./modules/nixos/virtualization/kvm
      ./modules/nixos/gaming/controllers
      ./modules/nixos/gaming/mouse
      ./modules/nixos/gaming/wine
      ./modules/nixos/gaming/simracing
      ./modules/nixos/gaming/vr
      ./modules/nixos/gaming/launchers
      ./modules/nixos/creative/video
      ./modules/nixos/creative/photo
      ./modules/nixos/creative/music
      ./modules/nixos/creative/multid
      ./modules/nixos/mapping/qgis
    ];

    # Home-manager modules loaded for Linux users
    homeModules = [
      plasma-manager.homeModules.plasma-manager
      sops-nix.homeModules.sops
      ./modules/home/settings/plasma
      ./modules/home/programs/git
      ./modules/home/programs/fish
      ./modules/home/programs/vscode
      ./modules/home/packages/utilities
      ./modules/home/packages/productivity
      ./modules/home/packages/communication
      ./modules/home/packages/development
      ./modules/home/packages/ides
      ./modules/home/packages/media
      ./modules/home/packages/editing
    ];

    # Home-manager modules loaded for the macOS user
    darwinHomeModules = [
      sops-nix.homeModules.sops
      ./modules/home/darwin
      ./modules/home/programs/git
      ./modules/home/programs/fish
      ./modules/home/programs/vscode
      ./modules/home/packages/utilities
      ./modules/home/packages/productivity
      ./modules/home/packages/communication
      ./modules/home/packages/development
      ./modules/home/packages/ides
      ./modules/home/packages/media
      ./modules/home/packages/editing
    ];
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = mkSpecialArgs {username = "dyrkon";};
        modules =
          fullNixosModules
          ++ [
            sops-nix.nixosModules.sops
            vscode-server.nixosModules.default
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = mkSpecialArgs {};
                users.dyrkon = {
                  imports = homeModules ++ [(./homes/x86_64-linux + "/dyrkon@nixos")];
                };
              };
            }
            ./systems/x86_64-linux/nixos
          ];
      };

      facis-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = mkSpecialArgs {username = "dyrkon";};
        modules =
          fullNixosModules
          ++ [
            sops-nix.nixosModules.sops
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = mkSpecialArgs {};
                users.dyrkon = {
                  imports = homeModules ++ [(./homes/x86_64-linux + "/dyrkon@facis-nixos")];
                };
              };
            }
            ./systems/x86_64-linux/facis-nixos
          ];
      };

      arm-test = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = mkSpecialArgs {username = "dyrkon";};
        modules = [
          sops-nix.nixosModules.sops
          disko.nixosModules.disko
          ./modules/shared/nix
          ./modules/nixos/nix
          ./modules/nixos/settings/networking
          ./modules/nixos/terminal/shell/fish
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = mkSpecialArgs {};
              users.dyrkon = {
                imports = [(./homes/aarch64-linux + "/dyrkon@arm-test")];
              };
            };
          }
          ./systems/aarch64-linux/arm-test
        ];
      };
    };

    darwinConfigurations = {
      macpro = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = mkSpecialArgs {username = "matej";};
        modules = [
          sops-nix.darwinModules.sops
          ./modules/shared/nix
          ./modules/darwin/nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = mkSpecialArgs {};
              users.matej = {
                imports = darwinHomeModules ++ [(./homes/aarch64-darwin + "/matej@macpro")];
              };
            };
          }
          ./systems/aarch64-darwin/macpro
        ];
      };
    };

    devShells = let
      mkShells = pkgs: {
        c = pkgs.callPackage ./shells/c {};
        c-mpi = pkgs.callPackage ./shells/c-mpi {};
        c-qt = pkgs.callPackage ./shells/c-qt {};
        cyberSec = pkgs.callPackage ./shells/cyberSec {};
        dotnet = pkgs.callPackage ./shells/dotnet {};
        dotnet8 = pkgs.callPackage ./shells/dotnet8 {};
        python-data-analysis = pkgs.callPackage ./shells/python-data-analysis {};
      };
    in {
      x86_64-linux = mkShells nixpkgs.legacyPackages.x86_64-linux;
      aarch64-darwin = mkShells nixpkgs-darwin.legacyPackages.aarch64-darwin;
    };

    overlays = {
      steam = import ./overlays/steam;
    };

    formatter = {
      x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
      aarch64-darwin = nixpkgs-darwin.legacyPackages.aarch64-darwin.alejandra;
    };
  };
}
