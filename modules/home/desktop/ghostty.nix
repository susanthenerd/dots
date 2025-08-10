{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "gruvbox-material";
      font-family = [
        "RecMonoDuotone Nerd Font Mono"
        "FontAwesome"
      ];

      window-decoration = "server";
      adw-toolbar-style = "flat";
      gtk-wide-tabs = false;
    };
  };
}
