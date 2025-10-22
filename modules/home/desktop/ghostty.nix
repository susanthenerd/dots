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
      theme = "Gruvbox Dark Hard";
      font-family = [
        "RecMonoDuotone Nerd Font Mono"
        "FontAwesome"
      ];

      window-decoration = "server";
      adw-toolbar-style = "flat";
      gtk-wide-tabs = false;
      shell-integration-features = "ssh-env";
    };
  };
}
