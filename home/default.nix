{ config, lib, pkgs, ... }:
{
  imports = [
    ./sway
    ./fish
    ./starship
    ./i3status-rust
    ./eza
    ./foot
    ./github-cli
  ];

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
    home-manager = {
      enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  # services = { };

  gtk = {
    enable = true;
  };

}
