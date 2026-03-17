{...}: {
  flake.homeModules.i3wsr = {pkgs, ...}: {
    home.packages = with pkgs; [
      i3wsr
    ];

    xdg.configFile."i3wsr/config.toml".source = (pkgs.formats.toml {}).generate "config.toml" {
      general = {
        separator = "|";
        display_property = "name";
      };

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
          "Slack" = "Slack";
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
          "1password" = "1Password";
          "super-productivity" = "Super Productivity";
          "org.prismlauncher.PrismLauncher" = "Prism Launcher";
          "windsurf" = "Code";
          "org.pulseaudio.volumecontrol" = "Volume";
          "org.keepassxc.KeePassXC" = "Keepass";
          "Mullvad VPN" = "Mullvad";
        };
      };

      icons = {
        "Slack" = "";
        "firefox" = "";
        "Chrome" = "";
        "CLion" = "";
        "Rust Rover" = "";
        "PyCharm" = "";
        "Code" = "";
        "Discord" = "󰙯";
        "Ghostty" = "";
        "Steam" = "";
        "obs" = "";
        "virt-manager" = "";

        "nvim.*" = "";
        "steam*" = "";
        "Youtube Music" = "";
        "Claude" = "";
        "looking-glass" = "";
        "1Password" = "󰌆";
        "heroic" = "";
        "ticktick" = "";
        "Nautilus" = "";
        "Prism Launcher" = "";
        "Volume" = "󰎄";
        "Super Productivity" = "";
        "emacs" = "";
        "Mullvad" = "";
        "Keepass" = "󰌆";
      };

      options = {
        remove_duplicates = false;
        no_icon_names = true;
      };
    };
  };
}
