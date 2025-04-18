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

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  programs = {
    hyprland.enable = false;
    sway.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "susan" ];
    };
    thunar.enable = true;
    firefox.enable = true;
    steam.enable = true;
    virt-manager.enable = true;
    nix-ld.enable = true;
  };

  services = {
    # udev.packages = [ pkgs.yubikey-personalization ];
    pcscd.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    power-profiles-daemon.enable = true;
    fprintd.enable = true;
    pulseaudio.enable = false;
    gvfs.enable = true;
    blueman.enable = true;
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
  ];
  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
        data-root = "/data/docker";
      };
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
      };
    };
  };

  security.pam.services.sddm.enableGnomeKeyring = true;
}
