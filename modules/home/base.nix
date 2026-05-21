{
  self,
  inputs,
  ...
}: {
  flake.homeModules.base = {pkgs, packages, ...}: {
    imports = [
      self.homeModules.desktop
      self.homeModules.shell
      self.homeModules.emacs
      self.homeModules.vscode
      self.homeModules.discord
      self.homeModules.cybesecurity
    ];

    home = {
      username = "susan";
      homeDirectory = "/home/susan";

      sessionVariables = {
        "NIXOS_OZONE_WL" = "1";
      };

      packages =
        (with pkgs; [
          brightnessctl
          vlc
          gdb
          cmake

          # jetbrains.clion

          grim
          slurp
          wl-clipboard
          wget
          unzip
          deploy-rs
          age
          sops
          devenv

          (discord-canary)

          brightnessctl
          playerctl

          easyeffects
          btop
          nautilus
          
          pavucontrol
          gcc
          libreoffice
          signal-desktop


          prismlauncher
        ])
        ++ [
          packages.t3code
        ]
        ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
          opencode
          codex
        ]);

      stateVersion = "26.05";
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
      defaultSopsFile = ../../secrets/xps.yaml;
      age.keyFile = "/home/susan/.config/sops/age/keys.txt";
    };
  };
}
