{ config, lib, pkgs, ...}:
let
  fontPackage = pkgs.nerdfonts.override { fonts = [ "FiraCode" "Recursive" "Monaspace" ]; };


in {
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    image = ../../bg.png;

    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-dark";
    };
    fonts = {
      monospace = {
        name = "RecMonoDuotone Nerd Font Mono";
        package = fontPackage;
      };

      sizes = {
        applications = 14;
        desktop = 10;
        popups = 12;
        terminal = 14;
      };
    };

  };
}
