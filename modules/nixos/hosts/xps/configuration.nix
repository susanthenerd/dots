{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.xps = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostXps
    ];
  };

  flake.nixosModules.hostXps = {pkgs, ...}: {
    imports = [
      self.nixosModules.xpsHardware
      self.nixosModules.xpsKanata
#      self.nixosModules.xpsLlamaServer
      self.nixosModules.nixCommon
      self.nixosModules.kvmfr
#      self.nixosModules.llamaServer

      inputs.sops-nix.nixosModules.sops
      inputs.disko.nixosModules.disko
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.home-manager.nixosModules.home-manager
      inputs.nixos-hardware.nixosModules.dell-xps-15-9570-nvidia

      self.diskoConfigurations.hostXps
    ];

    nixpkgs.overlays = [
      self.overlays.looking-glass
      self.overlays.cmake
      inputs.emacs-overlay.overlay
      self.overlays.multiviewer
    ];
    nixpkgs.config = {
      allowUnfree = true;
      rocmSupport = true;
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
    time.timeZone = "Europe/Bucharest";
    security.polkit.enable = true;

    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.recursive-mono
      fira
      recursive
    ];

    users = {
      mutableUsers = false;
      defaultUserShell = pkgs.fish;
      users.susan = {
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
      _1password.enable = true;
      _1password-gui = {
        enable = true;
        polkitPolicyOwners = ["susan"];
      };
      steam.enable = true;
      virt-manager.enable = true;
      nix-ld.enable = true;
      sway = {
        enable = true;
        extraPackages = [];
        package = pkgs.swayfx;
      };
    };

    environment.systemPackages = with pkgs; [
      nixd
      nixfmt-rfc-style
      sbctl
      pciutils
      killall

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
      udev.packages = [pkgs.yubikey-personalization];
      pcscd.enable = true;

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

      mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
      };
      resolved.enable = true;

      fprintd.enable = true;
      pulseaudio.enable = false;
      gvfs.enable = true;
      livebook.enableUserService = true;

      tuned = {
        enable = true;
        ppdSupport = true;
      };
    };

    powerManagement = {
      enable = true;
      powertop.enable = true;
    };

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

    xdg.portal = {
      enable = true;
      config.common.default = "*";
    };

    security.pam.services.sddm.enableGnomeKeyring = true;
    documentation.nixos.enable = false;
    system.stateVersion = "25.05";

    # home-manager
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "bak";
      extraSpecialArgs = {
        inherit inputs;
        packages = self.packages.${pkgs.stdenv.hostPlatform.system};
      };
      users.susan = {
        imports = [
          self.homeModules.base
        ];
      };
      sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];
    };
  };
}
