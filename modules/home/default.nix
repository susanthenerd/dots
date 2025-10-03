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
    ./shell
  ];

  home = {
    username = "susan";
    homeDirectory = "/home/susan";

    sessionVariables = {
      "NIXOS_OZONE_WL" = 1;
    };

    packages =
      with pkgs;
      [
        htop
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
        (discord.override {
          withMoonlight = true;
        })

        brightnessctl
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

        morgen
        todoist-electron

      ]
      ++ (with inputs.nix-ai-tools.packages.${pkgs.system}; [
        codex
        claude-code
      ]);

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
