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

    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    i915-sriov-dkms = {
      url = "github:strongtz/i915-sriov-dkms";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    nix-ai-tools.url = "github:numtide/nix-ai-tools";
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
      i915-sriov-dkms,
      quadlet-nix,
      sops-nix,
      deploy-rs,
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
          };

          nixosConfigurations = {
            framework = withSystem "x86_64-linux" (
              {
                config,
                inputs',
                pkgs,
                ...
              }:
              nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = {
                  packages = config.packages;

                  inherit inputs inputs';
                };

                modules = [
                  { nixpkgs = { inherit pkgs; }; }
                  {
                    nix.settings = {
                      substituters = [
                        "https://nix-community.cachix.org"
                        "https://devenv.cachix.org"
                        "https://cache.nixos.org"
                      ];
                      trusted-public-keys = [
                        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
                      ];
                    };
                  }

                  ./hosts/framework
                  ./hosts/configuration.nix
                  ./modules/nix-common.nix
                  ./modules/nixos/sriov.nix

                  i915-sriov-dkms.nixosModules.default

                  home-manager.nixosModules.home-manager
                  {
                    home-manager = {
                      useUserPackages = true;
                      useGlobalPkgs = true;
                      backupFileExtension = "bak";
                      extraSpecialArgs = { inherit inputs; };
                      users.susan = {
                        imports = [
                          ./modules/home
                        ];
                      };
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
              ];
              config = {
                allowUnfree = true;
              };
            };
          };
      }
    );
}
