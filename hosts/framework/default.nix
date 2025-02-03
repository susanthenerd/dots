{ config, pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ./disko.nix ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    wlr.enable = true;
  };


  programs = {
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
  };

  environment.systemPackages = [
    pkgs.s-tui
    pkgs.stress-ng
  ];

  environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];

  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
        data-root = "/data/docker";
      };
    };

    libvirtd = {
      enable = true;
    };
  };
  security.pam.services.sddm.enableGnomeKeyring = true;
}
