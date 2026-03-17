{...}: {
  flake.homeModules.xdg = {pkgs, ...}: {
    xdg = {
      enable = true;
      portal = {
        enable = true;
        config = {
          sway = {
            default = ["gtk"];
            "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
            "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
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
          "x-scheme-handler/http" = ["handlr-dispatcher.desktop"];
          "x-scheme-handler/https" = ["handlr-dispatcher.desktop"];
          "application/pdf" = ["firefox.desktop"];
        };

        defaultApplicationPackages = [
          pkgs.firefox
        ];
      };
    };
  };
}
