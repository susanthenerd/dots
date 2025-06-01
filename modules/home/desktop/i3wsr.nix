{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    i3wsr
  ];

  xdg.configFile."i3wsr/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
    general = {
      separator = "|";
      # default_icon = "💀"; # Optional: Uncomment to set a default icon
      # empty_label = "🌕";   # Optional: Uncomment to set a label for empty workspaces
      display_property = "name";
    };

    # Aliases can be useful if window class/app_id is verbose or changes often
    # See https://github.com/roosta/i3wsr#aliases for details
    # aliases.class = {
    #   "^Google-chrome-stable$" = "Chrome";
    #   "firefox" = "Firefox";
    #   "Org\.gnome\.Nautilus" = "Nautilus";
    # };
    # aliases.app_id = { # For Wayland native apps
    #   "firefox" = "Firefox";
    # };
    # aliases.instance = {};
    # aliases.name = {};

    aliases = {
      class = {
        "Google-chrome" = "Chrome";
        "jetbrains-clion" = "CLion";
        "jetbrains-rustrover" = "Rust Rover";
        "Cursor" = "Code";
        "discord" = "Discord";
        "com.github.th_ch.youtube_music" = "Youtube Music";
      };

      app_id = {
        "virt-manager-wrapped" = "virt-manager";
      };
    };
    icons = {
      "firefox" = "";
      "Chrome" = "";
      "CLion" = "";
      "Rust Rover" = "";
      "Code" = "";
      "Discord" = "󰙯";
      "Alacritty" = "";
      "steam" = "";
      "obs" = "";
      "virt-manager" = "";
      "nvim.*" = "";
      "steam*" = "";
      "Youtube Music" = "";
    };

    options = {
      remove_duplicates = false;
      no_icon_names = true;
    };
  };
}
