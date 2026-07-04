{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.xps = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostXps
    ];
  };

  flake.nixosModules.hostXps =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      ewmEmacsPackage = config.programs.ewm.emacsPackage;
    in
    {
      imports = [
        self.nixosModules.xpsHardware
        #      self.nixosModules.xpsKanata
        #      self.nixosModules.xpsLlamaServer
        self.nixosModules.nixCommon
        #      self.nixosModules.kvmfr
        #      self.nixosModules.llamaServer

        inputs.sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.home-manager.nixosModules.home-manager
        inputs.nixos-hardware.nixosModules.dell-xps-15-9570-nvidia
        inputs.ewm.nixosModules.default

        self.diskoConfigurations.hostXps
      ];

      nixpkgs.overlays = [
        self.overlays.codex-desktop-linux
        #      self.overlays.looking-glass
        #      self.overlays.cmake
        inputs.emacs-overlay.overlay
        inputs.ewm.overlays.default
        self.overlays.ewm
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
        ewm = {
          enable = true;
          ewmPackage = pkgs.ewm;
          emacsPackage = pkgs.callPackage ../../../../packages/emacs-configured.nix {
            extraEmacsPackages = _epkgs: [
              config.programs.ewm.ewmPackage
            ];
          };
        };

        virt-manager.enable = true;
      };

      system.activationScripts.reloadEwmEmacs = lib.stringAfter [ "users" ] ''
        ewm_user=susan
        if ! ewm_uid="$(${pkgs.coreutils}/bin/id -u "$ewm_user" 2>/dev/null)"; then
          echo "ewm-emacs: skipping reload; user $ewm_user does not exist"
        else
          ewm_runtime_dir="/run/user/$ewm_uid"
          ewm_server="$ewm_runtime_dir/emacs/server"

          if [ ! -S "$ewm_server" ]; then
            echo "ewm-emacs: skipping reload; no Emacs server at $ewm_server"
          else
            echo "ewm-emacs: reloading config from ${ewmEmacsPackage}"
            if ! ewm_expr="$(${ewmEmacsPackage}/bin/emacs -Q --batch --eval '
        (let ((default (locate-library "default")))
          (unless default
            (error "Cannot locate default.el from NixOS EWM Emacs"))
          (prin1
           (append
            (list (quote progn)
                  (list (quote setq)
                        (quote load-path)
                        (list (quote quote) load-path)))
            (when (boundp (quote native-comp-eln-load-path))
              (list
               (list (quote setq)
                     (quote native-comp-eln-load-path)
                     (list (quote quote) native-comp-eln-load-path))))
            (list (list (quote load-file) default)))))
        ')"; then
              echo "ewm-emacs: warning: could not create reload expression; continuing"
            elif ! ${pkgs.util-linux}/bin/runuser -u "$ewm_user" -- \
              ${pkgs.coreutils}/bin/env XDG_RUNTIME_DIR="$ewm_runtime_dir" \
              ${ewmEmacsPackage}/bin/emacsclient --socket-name="$ewm_server" --eval "$ewm_expr" >/dev/null; then
              echo "ewm-emacs: warning: live reload failed; continuing"
            fi
          fi
        fi
      '';

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
        xwayland-satellite

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
        displayManager.defaultSession = "ewm";

        resolved.enable = true;

        fprintd.enable = true;
        pulseaudio.enable = false;
        gvfs.enable = true;
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
          ];
        };
        sharedModules = [
          inputs.sops-nix.homeManagerModules.sops
        ];
      };
    };
}
