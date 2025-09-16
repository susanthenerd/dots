{
  config,
  lib,
  pkgs,
  ...
}:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;

      trusted-substituters = [ "https://cache.nixos.org/" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}
