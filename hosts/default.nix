{ lib, inputs, nixpkgs, home-manager, ... }:
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

      home-manager.nixosModules.home-manager
      {
        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;

        home-manager.users.susan = {
          imports = [ ../home ];
        };
      }
    ];
  };
}
