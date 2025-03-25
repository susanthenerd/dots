{ config, lib, pkgs, ... }:
{
  imports = [
    ./sway
    ./swaylock
    ./fish
    ./starship
    ./i3status-rust
    # ./eza
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
    ./niri
    ./nushell
    ./hyprland
  ];

  home = {
    username = "susan";
    homeDirectory = "/home/susan";

    packages = with pkgs; [
      htop
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
      wget
      unzip
      vscode
      discord
      devenv
      looking-glass-client
      xwayland-satellite
    ];

    stateVersion = "24.11";
    shell = {
      enableNushellIntegration = true;
      enableFishIntegration = true;
    };
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
