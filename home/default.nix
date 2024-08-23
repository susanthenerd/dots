{ config, lib, pkgs, ... }:
{
  imports = [
    ./sway
    ./fish
    ./starship
    ./i3status-rust
    ./eza
    ./alacritty
    ./github-cli
    ./wofi
    ./git
  ];

  home = {
    username = "susan";
    homeDirectory = "/home/susan";

    packages = with pkgs; [
      bat
      foot
      neofetch
      htop
      discord
      firefox-devedition-bin
      polypane
      vscode
      nm-tray
      pavucontrol
      brightnessctl
      zed-editor
      vlc
      lutris
      lunar-client
      prismlauncher
    ];

    stateVersion = "24.05";
  };

  programs = {
    home-manager.enable = true;
    obs-studio.enable = true;
    google-chrome.enable = true;
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
