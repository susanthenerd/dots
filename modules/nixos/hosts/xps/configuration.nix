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
      rekaBaseEmacs = pkgs.callPackage ../../../../packages/emacs-pwayland-skia.nix {
        emacsSrc = inputs.emacs-pwayland;
      };
      rekaPackage = pkgs.callPackage ../../../../packages/emacs-reka.nix {
        emacsPackage = rekaBaseEmacs;
        src = inputs.reka;
      };
      rekaEarlyInit = pkgs.writeText "early-default.el" ''
        ;;; -*- lexical-binding: t; -*-

        (defvar susan/reka-early-bootstrap nil
          "Whether Reka was enabled by the pre-frame startup shim.")

        (defvar susan/reka-first-frame-timeout 15.0
          "Seconds to wait for Reka to request its first pwayl frame.")

        (defun susan/reka-enable-before-first-frame ()
          "Enable Reka and synchronously obtain its initial pwayl frame."
          (when (getenv "REKA_SESSION")
            (unless (and (eq initial-window-system 'pwayl)
                         (not noninteractive)
                         (zerop (recursion-depth))
                         (zerop (minibuffer-depth)))
              (error
               "Reka frame bootstrap requires interactive pwayl at depth 0/0"))
            (require 'reka)
            (setq reka-intercept-prefixes nil
                  susan/reka-early-bootstrap t)
            (let (capture-frame handle-on-pwayl make-first-frame)
              (setq capture-frame
                    (lambda (frame)
                      (when (and (not (frame-live-p frame-initial-frame))
                                 (eq (framep frame) 'pwayl))
                        (setq frame-initial-frame frame)))
                    handle-on-pwayl
                    (lambda (original &rest args)
                      (let ((window-system initial-window-system))
                        (apply original args))))
              (unwind-protect
                  (progn
                    (advice-add 'reka--handle-commands :around
                                handle-on-pwayl)
                    (add-hook 'after-make-frame-functions capture-frame)
                    (unless reka-handle
                      (reka-enable))
                    ;; Match stock `frame-initialize', while applying this
                    ;; snapshot to exactly the first Reka-requested frame.
                    (setq frame-initial-frame-alist
                          (cons (cons 'window-system initial-window-system)
                                (append initial-frame-alist
                                        default-frame-alist nil))
                          make-first-frame
                          (lambda (original &optional parameters)
                            (advice-remove 'make-frame make-first-frame)
                            (funcall original
                                     (append parameters
                                             frame-initial-frame-alist))))
                    (advice-add 'make-frame :around make-first-frame)
                    (let ((events (get-process "reka-events"))
                          (deadline (+ (float-time)
                                       susan/reka-first-frame-timeout)))
                      (unless events
                        (error "Reka event process was not created"))
                      (while (not (frame-live-p frame-initial-frame))
                        (unless (process-live-p events)
                          (error
                           "Reka event process stopped before creating a frame"))
                        (when (>= (float-time) deadline)
                          (error
                           "Reka did not create a pwayl frame within %.1f seconds"
                           susan/reka-first-frame-timeout))
                        ;; The pipe filter only schedules a timer; drain the
                        ;; queue directly while startup waits synchronously.
                        (reka--handle-commands)
                        (unless (frame-live-p frame-initial-frame)
                          (accept-process-output events 0.25))))
                    ;; Stock `frame-initialize' now adopts the existing frame,
                    ;; copies the terminal environment, and deletes the
                    ;; terminal frame.  pwayl itself initialized this frame as
                    ;; `default-minibuffer-frame' on the pwayl kboard.
                    (setq initial-frame-alist
                          (frame-remove-geometry-params initial-frame-alist)))
                (advice-remove 'make-frame make-first-frame)
                (advice-remove 'reka--handle-commands handle-on-pwayl)
                (remove-hook 'after-make-frame-functions capture-frame)))))

        (add-hook 'before-init-hook #'susan/reka-enable-before-first-frame)
      '';
      rekaEmacsPackage = pkgs.callPackage ../../../../packages/emacs-configured.nix {
        emacsSrc = inputs.emacs-pwayland;
        extraEmacsPackages = epkgs: [
          rekaPackage
          (epkgs.trivialBuild {
            pname = "early-default";
            version = "0.1.0";
            src = rekaEarlyInit;
            packageRequires = [ rekaPackage ];
          })
        ];
      };
      rekaSessionCommand = pkgs.writeShellScriptBin "reka-session" ''
        export REKA_SESSION=1
        exec ${pkgs.river}/bin/river -c ${rekaEmacsPackage}/bin/emacs
      '';
      rekaSession =
        pkgs.runCommand "reka-wayland-session"
          {
            passthru.providedSessions = [ "reka" ];
          }
          ''
            mkdir -p "$out/share/wayland-sessions"
            cat > "$out/share/wayland-sessions/reka.desktop" <<EOF
            [Desktop Entry]
            Name=Reka
            Comment=Emacs window manager for River
            Exec=${rekaSessionCommand}/bin/reka-session
            Type=Application
            DesktopNames=reka
            EOF
          '';
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
        self.diskoConfigurations.hostXps
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
        wlr.enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.reka.default = [
          "wlr"
          "gtk"
        ];
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
        virt-manager.enable = true;
      };

      system.activationScripts.reloadRekaEmacs = lib.stringAfter [ "users" ] ''
        reka_user=susan
        if ! reka_uid="$(${pkgs.coreutils}/bin/id -u "$reka_user" 2>/dev/null)"; then
          echo "reka-emacs: skipping reload; user $reka_user does not exist"
        else
          reka_runtime_dir="/run/user/$reka_uid"
          reka_server="$reka_runtime_dir/emacs/server"

          if [ ! -S "$reka_server" ]; then
            echo "reka-emacs: skipping reload; no Emacs server at $reka_server"
          else
            echo "reka-emacs: reloading config from ${rekaEmacsPackage}"
            if ! reka_expr="$(${rekaEmacsPackage}/bin/emacs -Q --batch --eval '
        (let ((default (locate-library "default")))
          (unless default
            (error "Cannot locate default.el from NixOS Reka Emacs"))
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
              echo "reka-emacs: warning: could not create reload expression; continuing"
            elif ! ${pkgs.util-linux}/bin/runuser -u "$reka_user" -- \
              ${pkgs.coreutils}/bin/env XDG_RUNTIME_DIR="$reka_runtime_dir" \
              ${rekaEmacsPackage}/bin/emacsclient --socket-name="$reka_server" --eval "$reka_expr" >/dev/null; then
              echo "reka-emacs: warning: live reload failed; continuing"
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
        glib
        river

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
        displayManager.sessionPackages = [ rekaSession ];
        displayManager.defaultSession = "reka";

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
