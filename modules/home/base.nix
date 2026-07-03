{
  self,
  inputs,
  ...
}:
{
  flake.homeModules.base =
    { pkgs, packages, ... }:
    {
      imports = [
        self.homeModules.desktop
        self.homeModules.shell
        self.homeModules.emacs
        self.homeModules.vscode
        self.homeModules.discord
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

            grim
            slurp
            wl-clipboard
            wget
            unzip
            deploy-rs
            age
            sops
            devenv

            brightnessctl
            playerctl
            cloudflared
            beekeeper-studio
            easyeffects
            btop
            nautilus

            pavucontrol
            libreoffice
            signal-desktop
            slack
            super-productivity
            prismlauncher
          ])
          ++ [
            packages.t3code
          ]
          ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
            opencode
            claude-code
            codex
          ]);

        stateVersion = "26.11";
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
