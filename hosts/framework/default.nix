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
    ./kanata.nix
    ../../modules/nixos/kvmfr.nix
    ../../modules/nixos/llama-server.nix
    ./llama-server.nix
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
      extraSessionCommands = ''
        #        export WLR_DRM_DEVICES=/dev/dri/card7
      '';
    };

  };

  services = {
    udev.packages = [ pkgs.yubikey-personalization ];
    pcscd.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    fwupd.enable = true;
    ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      rocmOverrideGfx = "11.0.0";
    };

    open-webui = {
      enable = true;
      host = "127.0.0.1";
      port = 11111;
    };

    blueman.enable = true;
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
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

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
      qemu-system-x86_64 \
        -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
        "$@"
    '')

    pkgs.ryzenadj
    pkgs.rocmPackages.rocminfo
    pkgs.rocmPackages.rocsolver
    pkgs.clinfo
    pkgs.nvtopPackages.amd

    pkgs.stress-ng
    pkgs.s-tui
    pkgs.framework-tool
    pkgs.fw-ectool
    pkgs.powertop

    pkgs.pcsclite
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
