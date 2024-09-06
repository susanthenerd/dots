{ config, pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ./disko.nix ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    wlr.enable = true;
  };


  programs = {
    steam.enable = true;
    sway.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["susan"];
    };
    thunar.enable = true;
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
  };

  environment.systemPackages = [
    pkgs.s-tui
    pkgs.stress-ng
  ];

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
