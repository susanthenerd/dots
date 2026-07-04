{ ... }:
{
  flake.homeModules.xdg =
    { pkgs, ... }:
    {
      xdg = {
        enable = true;

        mimeApps = {
          enable = true;
          defaultApplications = {
            "x-scheme-handler/http" = [ "firefox.desktop" ];
            "x-scheme-handler/https" = [ "firefox.desktop" ];
            "application/pdf" = [ "firefox.desktop" ];
          };

          defaultApplicationPackages = [
            pkgs.firefox
          ];
        };
      };
    };
}
