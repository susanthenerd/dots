{
  self,
  inputs,
  ...
}:
{
  flake.homeModules.onsc =
    { pkgs, packages, ... }:
    {
      imports = [
        self.homeModules.shell
        self.homeModules.ghostty
        self.homeModules.vscode
      ];

      home = {
        username = "onsc";
        homeDirectory = "/home/onsc";

        sessionVariables = {
          "NIXOS_OZONE_WL" = "1";
          "GST_PLUGIN_SYSTEM_PATH_1_0" = "${pkgs.gst_all_1.gstreamer.out.outPath}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-ugly}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-libav}/lib/gstreamer-1.0";
        };

        packages = (
          with pkgs;
          [
            brightnessctl
            vlc
            gst_all_1.gstreamer
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            gst_all_1.gst-plugins-bad
            gst_all_1.gst-plugins-ugly
            gst_all_1.gst-libav
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

            brightnessctl
            playerctl

            easyeffects
            btop
            nautilus
            

            pavucontrol
            gcc
            libreoffice
          ]
        ) ++ [
          packages.xwaylandvideobridge
          
        ];

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

      xdg = {
        enable = true;
        portal = {
          enable = true;
          config.common.default = [ "kde" ];
          extraPortals = [
            pkgs.kdePackages.xdg-desktop-portal-kde
          ];
        };
      };

      wayland.windowManager.sway.config.modifier = "Mod1";

      sops = {
        defaultSopsFile = ../../secrets/xps.yaml;
        age.keyFile = "/home/susan/.config/sops/age/keys.txt";
      };
    };
}
