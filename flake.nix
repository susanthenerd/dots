{
  description = "My nixos config with included mess";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm-nix = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
    llm-agents.url = "github:numtide/llm-agents.nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      home-manager,
      disko,
      lanzaboote,
      quadlet-nix,
      sops-nix,
      deploy-rs,
      microvm-nix,
      emacs-overlay,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {

        flake = {
          overlays = {
            looking-glass-overlay = import ./overlays/looking-glass-client.nix;
            cmake-overlay = import ./overlays/cmake.nix;
            multiviewer-overlay = import ./overlays/multiviewer.nix;
          };

          nixosConfigurations = {
            framework = withSystem "x86_64-linux" (
              {
                config,
                inputs',
                ...
              }:
              let
                pkgs = import nixpkgs {
                  system = "x86_64-linux";
                  overlays = [
                    top.config.flake.overlays.looking-glass-overlay
                    top.config.flake.overlays.cmake-overlay
                    emacs-overlay.overlay
                    top.config.flake.overlays.multiviewer-overlay
                  ];
                  config = {
                    allowUnfree = true;
                    rocmSupport = true;
                  };
                };
              in
              nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = {
                  packages = config.packages;

                  inherit inputs inputs';
                };

                modules = [
                  {
                    nixpkgs = { inherit pkgs; };
                  }
                  {
                    nix.settings = {
                      substituters = [
                        "https://nix-community.cachix.org"
                        "https://devenv.cachix.org"
                        "https://cache.nixos.org"
                        "https://cache.numtide.com"
                        "https://microvm.cachix.org"
                      ];
                      trusted-public-keys = [
                        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
                        "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
                        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
                      ];
                    };
                  }

                  sops-nix.nixosModules.sops

                  ./hosts/framework
                  ./hosts/configuration.nix
                  ./modules/nix-common.nix

                  home-manager.nixosModules.home-manager
                  {
                    home-manager = {
                      useUserPackages = true;
                      useGlobalPkgs = true;
                      backupFileExtension = "bak";
                      extraSpecialArgs = {
                        inherit inputs;
                        packages = config.packages;
                      };
                      users.susan = {
                        imports = [
                          ./modules/home
                        ];
                      };

                      sharedModules = [
                        sops-nix.homeManagerModules.sops
                      ];
                    };
                  }

                  disko.nixosModules.disko
                  lanzaboote.nixosModules.lanzaboote

                ];
              }
            );

          };

        };
        systems = [ "x86_64-linux" ];

        perSystem =
          {
            config,
            pkgs,
            system,
            ...
          }:
          {

            _module.args.pkgs = import nixpkgs {
              inherit system;
              overlays = [
                top.config.flake.overlays.looking-glass-overlay
                top.config.flake.overlays.cmake-overlay
                emacs-overlay.overlay
                top.config.flake.overlays.multiviewer-overlay
              ];
              config = {
                allowUnfree = true;
              };
            };

            packages = {
              pano-scrobbler = pkgs.callPackage ./packages/pano-scrobbler.nix { };
              jackbox-utility = pkgs.callPackage ./packages/jackbox-utility.nix { };
            };
          };
      }
    );
}
