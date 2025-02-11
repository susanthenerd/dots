{ lib, inputs, nixpkgs, home-manager, disko, lanzaboote, ... }:
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
          substituters = [ 
            "https://nix-community.cachix.org"
            "https://devenv.cachix.org"
          ];
          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          ];
        };
      }

      ./framework
      ./configuration.nix

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
