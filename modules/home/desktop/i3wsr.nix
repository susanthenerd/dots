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
        "jetbrains-pycharm" = "PyCharm";
        "Cursor" = "Code";
        "ticktick" = "ticktick";
        "steam" = "Steam";
      };

      app_id = {
        "virt-manager-wrapped" = "virt-manager";
        "com.mitchellh.ghostty" = "Ghostty";
        "firefox" = "firefox";
        "looking-glass-client" = "looking-glass";
        "google-chrome" = "Chrome";
        "cursor" = "Code";
        "discord" = "Discord";
        "com.github.th_ch.youtube_music" = "Youtube Music";
        "ticktick" = "ticktick";
        "org.gnome.Nautilus" = "Nautilus";
        "1Password" = "1Password";
        "org.prismlauncher.PrismLauncher" = "Prism Launcher";
      };

    };
    icons = {
      "firefox" = "";
      "Chrome" = "";
      "CLion" = "";
      "Rust Rover" = "";
      "PyCharm" = "";
      "Code" = "";
      "Discord" = "󰙯";
      "Ghostty" = "";
      "Steam" = "";
      "obs" = "";
      "virt-manager" = "";
      "nvim.*" = "";
      "steam*" = "";
      "Youtube Music" = "";
      "Claude" = "";
      "looking-glass" = "";
      "1Password" = "󰌆";
      "heroic" = "";
      "ticktick" = "";
      "Nautilus" = "";
      "Prism Launcher" = "";
    };

    options = {
      remove_duplicates = false;
      no_icon_names = true;
    };
  };
}
