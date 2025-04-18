{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./sway
    ./i3status-rust
    ./swaylock
    ./fish
    ./starship
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
    ./hyprland
    ./senpai
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
      devenv
      looking-glass-client
      xwayland-satellite
      nautilus
      (discord.override {
        withVencord = true;
      })
      gimp
      prismlauncher
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
