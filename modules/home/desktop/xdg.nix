{...}: {
  flake.homeModules.xdg = {pkgs, ...}: {
    xdg = {
      enable = true;
      portal = {
        enable = true;
                  config.common.default = [ "wlr" ];

        extraPortals = [
          
          pkgs.xdg-desktop-portal-wlr
        ];
      };

      mimeApps = {
        enable = true;
        defaultApplications = {
          "x-scheme-handler/http" = ["firefox.desktop"];
          "x-scheme-handler/https" = ["firefox.desktop"];
          "application/pdf" = ["firefox.desktop"];
        };

        defaultApplicationPackages = [
          pkgs.firefox
        ];
      };
    };
  };
}
