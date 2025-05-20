{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  xdg = {
    enable = true;
    portal = {
      enable = true;
      config = {
        sway = {
          default = [ "kde" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        };
      };

      extraPortals = [
        # pkgs.xdg-desktop-portal-cosmic
        pkgs.xdg-desktop-portal-wlr
        pkgs.kdePackages.xdg-desktop-portal-kde
      ];
    };
  };
}
