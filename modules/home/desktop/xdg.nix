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
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        };
      };

      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];

    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        # see handlr-regex.nix for more details
        "x-scheme-handler/http" = [ "handlr-dispatcher.desktop" ];
        "x-scheme-handler/https" = [ "handlr-dispatcher.desktop" ];
      };
    };
  };
}
