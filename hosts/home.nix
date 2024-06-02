{ config, lib, pkgs, ... }:
{
  home = {
    username = "susan";
    homeDirectory = "/home/susan";

    packages = with pkgs; [
      neofetch
      htop
    ];

    stateVersion = "24.05";
  };

  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };

  # services = { };

  gtk = {
    enable = true;
  };
}
