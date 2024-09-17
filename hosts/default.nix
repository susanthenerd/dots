{ lib, inputs, nixpkgs, home-manager, disko, stylix, lanzaboote, ... }:
let
  system = "x86_64_linux";
in
{
  framework = lib.nixosSystem {
    inherit system;

    modules = [
      {
        nixpkgs = {
          config.allowUnfree = true;
        };

        nix.settings = {
          substituters = [ "https://nix-community.cachix.org" ];
          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
        };
      }

      ./framework
      ./configuration.nix
      ../home/stylix


      stylix.nixosModules.stylix

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
          backupFileExtension = "bak";

          users.susan = {
            imports = [ ../home ];
          };

        };
      }

      disko.nixosModules.disko
      lanzaboote.nixosModules.lanzaboote
    ];
  };
}
