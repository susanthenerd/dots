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
      "NIXOS_OZONE_WL" = "1";

    };

    packages =
      (with pkgs; [
        lutris

        brightnessctl
        vlc
        gdb
        cmake

        jetbrains.clion
        jetbrains-toolbox

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
          withVencord = true;
        })

        (bottles.override {
          removeWarningPopup = true;
        })

        brightnessctl
        obsidian
        lmstudio
        code-cursor
        playerctl

        pear-desktop
        easyeffects
        btop
        nautilus
        heroic
        prismlauncher
        nicotine-plus
        libation

        pavucontrol
        windsurf
        gcc
        libreoffice
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
    firefox = {
      enable = true;
      package = pkgs.firefox-bin;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    ripgrep.enable = true;
  };

  gtk = {
    enable = true;
  };

  sops = {
    defaultSopsFile = ../../secrets/framework.yaml;
    age.keyFile = "/home/susan/.config/sops/age/keys.txt";
  };

}
