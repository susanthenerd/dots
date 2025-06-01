{
  config,
  lib,
  pkgs,
  inputs,
  media-fetcher,
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

    packages =
      with pkgs;
      [
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
        grim
        slurp
        wl-clipboard
        wget
        unzip
        deploy-rs
        vscode
        age
        sops
        devenv
        looking-glass-client
        xwayland-satellite
        (discord.override {
          withMoonlight = true;
        })
        gimp
        prismlauncher
        brightnessctl
        code-cursor
        kdePackages.dolphin
        remmina
        playerctl
        solaar
        xournalpp
        rustup
        youtube-music
      ]
      ++ [ media-fetcher ];

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
    gpg.enable = true;
    ripgrep.enable = true;
  };

  services = {
    blueman-applet.enable = true;
    yubikey-agent.enable = true;
  };

  gtk = {
    enable = true;
  };

}
