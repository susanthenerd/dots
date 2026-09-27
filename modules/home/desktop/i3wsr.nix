{ ... }:
{
  flake.homeModules.i3wsr =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        i3wsr
      ];

      xdg.configFile."i3wsr/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
        general = {
          separator = "|";
          display_property = "name";
        };

        aliases = {
          class = {
            "Google-chrome" = "Chrome";
            "thunderbird" = "Thunderbird";
            "jetbrains-clion" = "CLion";
            "jetbrains-rustrover" = "Rust Rover";
            "jetbrains-pycharm" = "PyCharm";
            "jetbrains-idea" = "IDEA";
            "vlc" = "Vlc";
            "steam" = "Steam";
          };

          app_id = {
	    "jetbrains-idea" = "IDEA";
            "slack" = "Slack";
            "virt-manager-wrapped" = "virt-manager";
            "firefox" = "firefox";
            "thunderbird" = "Thunderbird";
            "looking-glass-client" = "looking-glass";
            "google-chrome" = "Chrome";
            "cursor" = "Code";
            "discord" = "Discord";
            "emacs" = "emacs";
            "com.github.th_ch.youtube_music" = "Youtube Music";
            "ticktick" = "ticktick";
            "org.gnome.Nautilus" = "Nautilus";
            "super-productivity" = "Super Productivity";
            "org.prismlauncher.PrismLauncher" = "Prism Launcher";
            "windsurf" = "Code";
            "org.pulseaudio.volumecontrol" = "Volume";
            "org.keepassxc.KeePassXC" = "Keepass";
            "codium" = "Codium";
            "signal" = "Signal";
          };
        };

        icons = {
          "Codium" = "";
          "Slack" = "";
          "firefox" = "";
          "Thunderbird" = "";
          "Chrome" = "";
          "CLion" = "";
          "Rust Rover" = "";
          "PyCharm" = "";
          "Code" = "";
          "Discord" = "󰙯";
          "Steam" = "";
          "obs" = "";
          "virt-manager" = "";
          "IDEA" = "";
          "nvim.*" = "";
          "steam*" = "";
          "Youtube Music" = "";
          "Claude" = "";
          "looking-glass" = "";
          "heroic" = "";
          "Nautilus" = "";
          "Prism Launcher" = "";
          "Volume" = "󰎄";
          "Super Productivity" = "";
          "emacs" = "";
          "Keepass" = "󰌆";
          "Signal" = "󰭹";
	  "Vlc" = "󰕼";
        };

        options = {
          remove_duplicates = false;
          no_icon_names = true;
        };
      };
    };
}
