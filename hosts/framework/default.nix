{ config, pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "framework";
    networkmanager.enable = true;
  };

  xdg.portal = {
    enable = true;
    # wlr.enable = true;
  };
}
