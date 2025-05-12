{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./desktop
    ./alacritty.nix
    ./shell
    ./vscode.nix

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
      jetbrains.rust-rover
      rustc
      rust-analyzer
      cargo
      grim
      slurp
      wl-clipboard
      wget
      unzip
      vscode
      devenv
      looking-glass-client
      xwayland-satellite
      (discord.override {
        withVencord = true;
      })
      gimp
      prismlauncher
      brightnessctl
      code-cursor
      remmina
      playerctl
    ];

    stateVersion = "24.11";
    shell = {
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
