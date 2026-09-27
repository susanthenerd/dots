{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.x1yoga = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostX1Yoga
    ];
  };

  flake.nixosModules.hostX1Yoga =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.x1YogaHardware
        self.nixosModules.nixCommon
        #      self.nixosModules.kvmfr
        #      self.nixosModules.llamaServer

        inputs.sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.home-manager.nixosModules.home-manager
        self.diskoConfigurations.hostX1Yoga
      ];

      nixpkgs.overlays = [
        self.overlays.waypipe
        #      self.overlays.looking-glass
        #      self.overlays.cmake
        inputs.emacs-overlay.overlay
        #      self.overlays.multiviewer
      ];
      nixpkgs.config = {
        allowUnfree = true;
      };

      nix.settings = {
        substituters = [
          "https://nix-community.cachix.org"
          "https://devenv.cachix.org"
          "https://cache.nixos.org"
          "https://cache.numtide.com"
          "https://microvm.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        ];
      };

      # shared configuration
      time.timeZone = null;
      services = {
        automatic-timezoned.enable = true;
        timesyncd.enable = true;
      };
      security = {
        polkit.enable = true;
        rtkit.enable = true;
      };

      xdg.portal = {
        enable = true;
        wlr = {
          enable = true;
          settings.screencast = {
            chooser_type = "dmenu";
            chooser_cmd = "${pkgs.fuzzel}/bin/fuzzel -d -l 10 -p 'Select a source to share:'";
          };
        };
        config.common.default = "*";
      };

      fonts.packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.recursive-mono
        fira
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        recursive
      ];

      users = {
        mutableUsers = false;
        defaultUserShell = pkgs.fish;
        users = {
          susan = {
            isNormalUser = true;
            extraGroups = [
              "docker"
              "wheel"
              "video"
              "networkmanager"
              "adbusers"
              "kvm"
              "libvirtd"
            ];
            hashedPassword = "$6$vru/Kz/2RFnBeCXQ$FPDE/DET/P2pNfE2bpVsEdDCeMegmeMApE4l3m/2YR9t6qCSrdiTzqUr8aN1gnOTAcYXBQ30NUf3UtqxINmDL.";
          };
        };
      };

      programs = {
        dconf.enable = true;
        fish.enable = true;
        neovim.enable = true;
        git.enable = true;
        nh = {
          enable = true;
          clean = {
            enable = true;
            extraArgs = "--keep 5 --keep-since 10d";
          };
          flake = "/home/susan/dots";
        };
        steam.enable = true;
        sway = {
          enable = true;
          extraPackages = [ ];
          package = pkgs.sway;
        };
        virt-manager.enable = true;
      };

      environment.systemPackages = with pkgs; [
        nixd
        nixfmt
        clang-tools
        elixir-ls
        rust-analyzer
        typescript
        typescript-language-server
        sbctl
        pciutils
        killall

        waypipe

        # ryzenadj
        # rocmPackages.rocminfo
        # rocmPackages.rocsolver
        # clinfo
        # nvtopPackages.amd

        stress-ng
        s-tui
        powertop

        pcsclite
        bluetui
        impala
        wiremix

        (writeShellScriptBin "qemu-system-x86_64-uefi" ''
          qemu-system-x86_64 \
            -bios ${OVMF.fd}/FV/OVMF.fd \
            "$@"
        '')
      ];

      services = {
        udev.packages = [ pkgs.yubikey-personalization ];
        pcscd.enable = true;
        openssh.enable = true;

        pipewire = {
          enable = true;
          pulse.enable = true;
        };

        fwupd.enable = true;
        flatpak.enable = true;
        gnome.gnome-keyring.enable = true;

        displayManager.sddm = {
          enable = true;
          wayland.enable = true;
        };
        displayManager.defaultSession = "sway";

        resolved.enable = true;

        fprintd.enable = true;
        pulseaudio.enable = false;
        gvfs.enable = true;
      };

      powerManagement.enable = true;

      virtualisation = {
        docker.enable = true;
        libvirtd = {
          enable = true;
          qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = true;
            swtpm.enable = true;

            verbatimConfig = ''
              cgroup_device_acl = [
                "/dev/null", "/dev/full", "/dev/zero",
                "/dev/random", "/dev/urandom",
                "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
                "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",
                "/dev/kvmfr0"
              ]
            '';
          };
        };
      };

      security.pam.services.sddm.enableGnomeKeyring = true;
      documentation.nixos.enable = false;
      system.stateVersion = "26.11";

      # home-manager
      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "bak";
        extraSpecialArgs = {
          inherit inputs;
          packages = self.packages.${pkgs.stdenv.hostPlatform.system};
        };
        users = {
          susan.imports = [
            self.homeModules.base
            self.homeModules.tablet
          ];
        };
        sharedModules = [
          inputs.sops-nix.homeManagerModules.sops
        ];
      };
    };
}
