{
  config,
  lib,
  pkgs,
  inputs,
  packages,
  ...
}:
{
  imports = [
    ./desktop
    ./shell

    ./emacs
  ];

  home = {
    username = "susan";
    homeDirectory = "/home/susan";

    sessionVariables = {
      "NIXOS_OZONE_WL" = 1;
    };

    packages =
      (with pkgs; [
        lutris
        htop
        pavucontrol
        brightnessctl
        vlc
        gdb
        cmake

        jetbrains.clion
        # jetbrains.rust-rover
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
        (discord.override {
          withEquicord = true;
        })

        (bottles.override {
          removeWarningPopup = true;
        })

        brightnessctl
        obsidian
        code-cursor
        remmina
        playerctl
        rustup
        youtube-music
        easyeffects
        btop
        nautilus
        heroic
        prismlauncher
        nicotine-plus
        libation

        windsurf
        slack
        super-productivity
        gcc
        signal-desktop
      ])
      ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
        opencode
        codex
        claude-code
        gemini-cli
      ])
      ++ [
        packages.pano-scrobbler
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

  services = {
    blueman-applet.enable = true;
  };

  gtk = {
    enable = true;
  };

  sops = {
    defaultSopsFile = ../../secrets/framework.yaml;
    age.keyFile = "/home/susan/.config/sops/age/keys.txt";
  };

}
