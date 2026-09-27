{ ... }:
{
  flake.homeModules.sway =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      modifier = config.wayland.windowManager.sway.config.modifier;
      terminal = config.wayland.windowManager.sway.config.terminal;
      menu = config.wayland.windowManager.sway.config.menu;
    in
    {
      wayland.windowManager.sway = {
        enable = true;
        package = null;
        config = {
          modifier = lib.mkDefault "Mod4";
          terminal = "emacs-terminal";
          menu = "${pkgs.fuzzel}/bin/fuzzel";

          fonts = {
            names = [ "RecMonoDuotone Nerd Font" ];
            size = "14";
          };

          startup = [
            { command = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets"; }
            { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
            { command = "discord"; }
            { command = "slack"; }
            { command = "thunderbird"; }
            {
              command = "${pkgs.i3wsr}/bin/i3wsr";
              always = true;
            }
            { command = "keepassxc --minimized"; }
          ];

          bars = [
            {
              fonts = {
                names = [
                  "RecMonoDuotone Nerd Font Mono"
                  "FontAwesome"
                ];
                style = "Regular";
                size = "14";
              };

              position = "bottom";
              statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
            }
          ];

          keybindings = {
            "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
            "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
            "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
            "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
            "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
            "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";

            "${modifier}+Shift+b" = "exec swaymsg bar mode toggle";
            "${modifier}+Return" = "exec ${terminal}";
            "${modifier}+Shift+Return" = "exec ${menu}";

            "${modifier}+Shift+c" = "kill";

            "${modifier}+Shift+y" = "move left";
            "${modifier}+Shift+h" = "move down";
            "${modifier}+Shift+a" = "move up";
            "${modifier}+Shift+e" = "move right";

            "${modifier}+Shift+Left" = "move left";
            "${modifier}+Shift+Down" = "move down";
            "${modifier}+Shift+Up" = "move up";
            "${modifier}+Shift+Right" = "move right";

            "${modifier}+Ctrl+y" = "focus left";
            "${modifier}+Ctrl+h" = "focus down";
            "${modifier}+Ctrl+a" = "focus up";
            "${modifier}+Ctrl+e" = "focus right";

            "${modifier}+Left" = "focus left";
            "${modifier}+Down" = "focus down";
            "${modifier}+Up" = "focus up";
            "${modifier}+Right" = "focus right";

            "--whole-window ${modifier}+button1" = "move";
            "--whole-window ${modifier}+button3" = "resize";

            "${modifier}+b" = "splith";
            "${modifier}+v" = "splitv";

            "${modifier}+Tab" = "exec ${pkgs.sway-easyfocus}/bin/sway-easyfocus focus";

            "${modifier}+s" = "layout stacking";
            "${modifier}+w" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";

            "${modifier}+f" = "fullscreen";

            "${modifier}+Shift+space" = "floating toggle";
            "${modifier}+space" = "focus mode_toggle";
            "${modifier}+a" = "focus parent";

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

            "Print" =
              "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.wl-clipboard}/bin/wl-copy";
            "Control+Print" = "exec ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy";
            "Shift+Print" =
              "exec ${pkgs.grim}/bin/grim ~/Pictures/screenshot-$(date +'%Y-%m-%d-%H-%M-%S' ).png";
            "${modifier}+Shift+Print" =
              "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - ~/Pictures/screenshot-slurp-$(date +'%Y-%m-%d-%H-%M-%S' ).png";

            "${modifier}+r" = "mode resize";

            "${modifier}+Ctrl+d" = "exec ${pkgs.kanshi}/bin/kanshictl switch docked";
            "${modifier}+Ctrl+Shift+d" = "exec ${pkgs.kanshi}/bin/kanshictl switch docked-rotated";
            "${modifier}+Shift+o" = "exec ${pkgs.swaylock}/bin/swaylock -fF";
            "${modifier}+Shift+r" = "reload";
            "${modifier}+Shift+Escape" =
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
              "y" = "resize shrink width 10 px";
              "h" = "resize grow height 10 px";
              "a" = "resize shrink height 10 px";
              "e" = "resize grow width 10 px";
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
      };
    };
}
