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
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    nix-ai-tools.url = "github:numtide/nix-ai-tools";
    flake-parts.url = "github:hercules-ci/flake-parts";

    deploy-rs.url = "github:serokell/deploy-rs";

    clan-core = {
      url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

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
      clan-core,
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

        imports = [
          clan-core.flakeModules.default
        ];

        flake = {
          overlays = {
            looking-glass-overlay = import ./overlays/looking-glass-client.nix;
            todoist-overlay = import ./overlays/todoist.nix;
          };

          clan = {
            meta.name = "my-clan";

            inventory = {
              machines = {
                framework = {
                  tags = [
                    "laptop"
                    "client"
                  ];
                };

              };

              # Instances are provided via clan.imports above
              instances = { };
            };
            machines = {

              framework = {
                nixpkgs.hostPlatform = "x86_64-linux";
                clan.core.networking.targetHost = "root@framework.tailnet.susan.lol";

                imports = [
                  ./hosts/framework
                  ./modules/nix-common.nix
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

                  {
                    environment.systemPackages = [ clan-core.packages."x86_64-linux".clan-cli ];
                  }

                  {

                    nix.settings = {
                      substituters = [ "https://devenv.cachix.org" ];
                      trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
                    };

                  }

                  disko.nixosModules.disko
                  lanzaboote.nixosModules.lanzaboote
                ];

              };

            };
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
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                top.config.flake.overlays.looking-glass-overlay
                top.config.flake.overlays.todoist-overlay
              ];
              config = { };
            };
          };
      }
    );
}
