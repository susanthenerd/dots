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
        self.homeModules.discord
      ];

      home = {
        username = "susan";
        homeDirectory = "/home/susan";

        sessionVariables = {
          "GTK_CSD" = "0";
          "NIXOS_OZONE_WL" = "1";
          "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
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
            easyeffects
            btop
            nautilus

            pavucontrol
            slack
            super-productivity
          ])
          ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
            opencode
            claude-code
            codex
            omp
          ]);

        stateVersion = "26.11";
        shell = {
          enableFishIntegration = true;
        };
      };

      programs = {
        home-manager.enable = true;
        thunderbird.enable = true;
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

      services.davmail = {
        enable = true;
        settings = {
          "davmail.mode" = "O365Graph";
          "davmail.authentication" = "O365DeviceCode";
          "davmail.enableOidc" = true;
          "davmail.allowRemote" = false;
          "davmail.bindAddress" = "127.0.0.1";
        };
      };

      gtk = {
        enable = true;
        gtk3.extraConfig = {
          "gtk-decoration-layout" = "";
        };
        gtk4.extraConfig = {
          "gtk-decoration-layout" = "";
        };
      };

      sops = {
        defaultSopsFile = ../../secrets/xps.yaml;
        age.keyFile = "/home/susan/.config/sops/age/keys.txt";
      };
    };
}
