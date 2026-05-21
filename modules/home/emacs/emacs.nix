{...}: {
  flake.homeModules.emacs = {pkgs, ...}: {
    programs.emacs = {
      enable = false;
      package =
        pkgs.emacsWithPackagesFromUsePackage {
          config = ./config.el;
          defaultInitFile = true;
          package = pkgs.emacs-pgtk;
        };
    };
  };
}
