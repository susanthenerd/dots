{ config, lib, pkgs, ... }:
{
  imports = [
    # ./sway
    ./emacs
    ./fish
    ./starship
    # ./i3status-rust
    ./eza
    ./alacritty
    ./github-cli
    ./waybar
    ./hyprland
    ./wofi
    # ./hyprlock
    # ./hypridle
  ];

  home = {
    username = "susan";
    homeDirectory = "/home/susan";

    packages = with pkgs; [
      neofetch
      htop
      discord
      firefox-devedition-bin
      polypane
      vscode
      nm-tray
      pavucontrol
      brightnessctl
      vlc
      helvum
      jetbrains.clion
      clang-tools
      cmake
      gdb
      clang
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
