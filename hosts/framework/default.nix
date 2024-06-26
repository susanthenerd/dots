{ config, pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ./disko.nix ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };


  programs = {
    hyprland.enable = true;
    steam.enable = true;
    hyprlock.enable = true;
  };

  services = {
    # udev.packages = [ pkgs.yubikey-personalization ];
    pcscd.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    gnome.gnome-keyring.enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
	data-root = "/data/docker";
      };
    };
  };

  security.pam.services.sddm.enableGnomeKeyring = true;

}

