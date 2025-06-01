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

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      home-manager,
      disko,
      lanzaboote,
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
          nixosConfigurations = {
            framework = nixpkgs.lib.nixosSystem {

              modules = [
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

                home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useUserPackages = true;
                    useGlobalPkgs = true;
                    backupFileExtension = "bak";
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
            };
          };
        };
        systems = [ "x86_64-linux" ];
        perSystem =
          { config, pkgs, ... }:
          {
            # Recommended: move all package definitions here.
            # e.g. (assuming you have a nixpkgs input)
            # packages.foo = pkgs.callPackage ./foo/package.nix { };
            # packages.bar = pkgs.callPackage ./bar/package.nix {
            #   foo = config.packages.foo;
            # };

          };
      }
    );
}
