{ config, lib, pkgs, ... }:
{
  imports = [
    ./sway
    ./fish
    ./starship
  ];
  home = {
    username = "susan";
    homeDirectory = "/home/susan";

    packages = with pkgs; [
      neofetch
      htop
      github-cli
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
