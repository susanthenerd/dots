{ config, lib, pkgs, ... }:
{
  imports = [
    ./sway
    ./swaylock
    ./fish
    ./starship
    ./i3status-rust
    ./eza
    ./alacritty
    ./github-cli
    ./fuzzel
    ./git
    ./ssh
    ./mako
    ./xdg
    ./fastfetch
    ./hyfetch
    ./swayidle
    ./fzf
    ./bat
  ];

  home = {
    username = "susan";
    homeDirectory = "/home/susan";

    packages = with pkgs; [
      htop
      firefox-devedition-bin
      polypane
      vscode
      nm-tray
      pavucontrol
      brightnessctl
      zed-editor
      vlc
      clang
      clang-tools
      gdb
      cmake
      jetbrains.clion
      grim
      slurp
      wl-clipboard
      vesktop
      wget

    ];

    stateVersion = "24.05";
  };

  programs = {
    home-manager.enable = true;
    obs-studio.enable = true;
    google-chrome.enable = true;
    firefox.enable = true;
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
