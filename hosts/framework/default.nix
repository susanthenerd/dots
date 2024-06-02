{ config, pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  xdg.portal = {
    enable = true;

    # wlr.enable = true;
  };
}
