{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "susan" ];
    };
    steam.enable = true;
    virt-manager.enable = true;
    nix-ld.enable = true;
    sway = {
      enable = true;
      extraPackages = [ ];
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    udev.packages = [ pkgs.yubikey-personalization ];
    pcscd.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    blueman.enable = true;
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };

      cosmic-greeter = {
        enable = false;
      };
    };

    desktopManager.cosmic = {
      enable = false;
      xwayland.enable = false;
    };
    power-profiles-daemon.enable = true;
    fprintd.enable = true;
    pulseaudio.enable = false;
    gvfs.enable = true;
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
      qemu-system-x86_64 \
        -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
        "$@"
    '')

    pkgs.stress-ng
    pkgs.s-tui
    pkgs.framework-system-tools
    pkgs.fw-ectool
    pkgs.powertop

    (pkgs.runCommand "intelgopdriver"
      {
      }
      ''
        mkdir -p $out/share/kvm

        cp ${./intelgopdriver.efi} $out/share/kvm/intelgopdriver_framework.bin
      ''
    )
  ];
  virtualisation = {
    docker = {
      enable = true;
    };

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              httpSupport = true;
              tpmSupport = true;
            }).fd
          ];
        };
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
    # extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # Add if needed
    # Silence warning about explicit portal backend config
    config.common.default = "*";
  };

  security.pam.services.sddm.enableGnomeKeyring = true;
}
