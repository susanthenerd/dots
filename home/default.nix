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
    ./yazi
    ./fzf
    ./bat
    ./zoxide
  ];

  home = {
    username = "susan";
    homeDirectory = "/home/susan";

    packages = with pkgs; [
      htop
      firefox-devedition-bin
      polypane
      nm-tray
      pavucontrol
      brightnessctl
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
      unzip
      vscode
      microsoft-edge
      obsidian
      discord
      teamspeak3
      devenv
      looking-glass-client
    ];

    stateVersion = "24.11";

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
    ripgrep.enable = true;
  };

  # services = { };

  gtk = {
    enable = true;
  };

}
