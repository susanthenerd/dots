{
  config,
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.sway = {
    enable = true;
    package = null;
    config = rec {
      modifier = "Mod4";
      terminal = "ghostty";
      menu = "${pkgs.fuzzel}/bin/fuzzel";

      fonts = {
        names = [ "RecMonoDuotone Nerd Font" ];
      };

      startup = [
        { command = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets"; }
        { command = "${pkgs._1password-gui}/bin/1password --silent"; }
        { command = "${pkgs.mako}/bin/mako"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        { command = "discord"; }
        {
          command = "${pkgs.i3wsr}/bin/i3wsr";
          always = true;
        }
        { command = "keepassxc --minimized"; }
        { command = "mullvad-vpn"; }
      ];

      bars = [
        {
          fonts = {
            names = [
              "RecMonoDuotone Nerd Font Mono"
              "FontAwesome"
            ];
            style = "Regular";
            size = 14.0;
          };

          position = "bottom";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
        }
      ];

      keybindings = {
        # Volume controls
        "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        # Brightness controls
        "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        # Media controls
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";

        #Launch stuff
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+Shift+Return" = "exec ${menu}";

        # Windows
        "${modifier}+Shift+c" = "kill";

        # Move focused window
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        # Alternative: Arrow keys for moving windows
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";

        # Move focus
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        # Alternative: Arrow keys for focus
        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";

        # Mouse binding for dragging floating windows
        "--whole-window ${modifier}+button1" = "move";
        "--whole-window ${modifier}+button3" = "resize";

        # Layouts
        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";

        # Switch the current container between different layout styles
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        "${modifier}+f" = "fullscreen";

        # Toggle the current focus between tiling and floating moder
        "${modifier}+Shift+space" = "floating toggle";

        # Swap focus between the tiling area and the floating area
        "${modifier}+space" = "focus mode_toggle";

        # Move focus to the parent container
        "${modifier}+a" = "focus parent";

        # Workspaces
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";

        # Screenshot
        "Print" =
          "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.wl-clipboard}/bin/wl-copy";
        "Control+Print" = "exec ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy";
        "Shift+Print" =
          "exec ${pkgs.grim}/bin/grim ~/Pictures/screenshot-$(date +'%Y-%m-%d-%H-%M-%S' ).png";
        "${modifier}+Shift+Print" =
          "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - ~/Pictures/screenshot-slurp-$(date +'%Y-%m-%d-%H-%M-%S' ).png";

        # Resize
        "${modifier}+r" = "mode resize";

        # Lock Screen
        "${modifier}+Shift+o" = "exec ${pkgs.swaylock}/bin/swaylock -fF";
        # Other keybindings
        "${modifier}+Shift+r" = "reload";
        "${modifier}+Shift+e" =
          "exec ${pkgs.sway}/bin/swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
      };

      output = {
        eDP-1 = {
          scale = "1";
        };
      };

      modes = {
        resize = {
          "Down" = "resize grow height 10 px";
          "Escape" = "mode default";
          "Left" = "resize shrink width 10 px";
          "Return" = "mode default";
          "Right" = "resize grow width 10 px";
          "Up" = "resize shrink height 10 px";
          "h" = "resize shrink width 10 px";
          "j" = "resize grow height 10 px";
          "k" = "resize shrink height 10 px";
          "l" = "resize grow width 10 px";
        };
      };

      window = {
        border = 2;
        titlebar = true;
      };
      workspaceAutoBackAndForth = true;

      input = {
        "2362:628:PIXA3854:00_093A:0274_Touchpad" = {
          dwt = "enabled";
          tap = "enabled";
        };

        "*" = {
          xkb_layout = "ro";
        };

      };
    };
    /*
      extraConfig = "
      corner_radius = 4;
      ";
    */
  };
}
