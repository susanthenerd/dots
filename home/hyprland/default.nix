{
  config,
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      pkgs.hyprlandPlugins.hy3
    ];
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "${pkgs.alacritty}/bin/alacritty";
      "$menu" = "fuzzel";

      monitor = [ "eDP-1, 2256x1504, 0x0, 1" ];

      general = {
        layout = "hy3";
        border_size = 2;
        no_border_on_floating = false;
        gaps_in = 0;
        gaps_out = 0;
      };

      plugin.hy3 = {
        tabs = {
          height = 22;
          padding = 6;
          render_text = true;
          text_center = true;
          text_font = "RecMonoDuotone Nerd Font";
          text_height = 8;
        };
        no_gaps_when_only = 1; # Similar to Sway's smart gaps
      };

      input = {
        "touchpad" = {
          natural_scroll = false;
          tap-to-click = true;
          disable_while_typing = true;
        };
      };

      bind =
        [
          # Volume controls
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

          # Brightness controls
          ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

          # Launch stuff
          "$mod, Return, exec, $terminal"
          "$mod SHIFT, Return, exec, $menu"

          # Windows
          "$mod SHIFT, C, killactive, "

          # Move focused window (hy3:movewindow instead of movewindow)
          "$mod SHIFT, H, hy3:movewindow, left"
          "$mod SHIFT, J, hy3:movewindow, down"
          "$mod SHIFT, K, hy3:movewindow, up"
          "$mod SHIFT, L, hy3:movewindow, right"

          # Alternative: Arrow keys for moving windows
          "$mod SHIFT, left, hy3:movewindow, left"
          "$mod SHIFT, down, hy3:movewindow, down"
          "$mod SHIFT, up, hy3:movewindow, up"
          "$mod SHIFT, right, hy3:movewindow, right"

          # Move focus (hy3:movefocus instead of movefocus)
          "$mod, H, hy3:movefocus, left"
          "$mod, J, hy3:movefocus, down"
          "$mod, K, hy3:movefocus, up"
          "$mod, L, hy3:movefocus, right"

          # Alternative: Arrow keys for focus
          "$mod, left, hy3:movefocus, left"
          "$mod, down, hy3:movefocus, down"
          "$mod, up, hy3:movefocus, up"
          "$mod, right, hy3:movefocus, right"

          # Layouts (hy3-specific commands)
          "$mod, B, hy3:makegroup, h"
          "$mod, V, hy3:makegroup, v"

          # Switch the current container between different layout styles
          "$mod, S, hy3:changegroup, tab"
          "$mod, W, hy3:changegroup, tab"
          "$mod, E, hy3:changegroup, opposite"

          "$mod, F, fullscreen, 0"

          # Toggle the current focus between tiling and floating mode
          "$mod SHIFT, space, togglefloating, "

          # Swap focus between the tiling area and the floating area
          "$mod, space, togglefloating, "

          # Move focus to the parent container
          "$mod, A, hy3:changefocus, raise"

          # Screenshot
          ", Print, exec, slurp | grim -g - - | wl-copy"
          "CTRL, Print, exec, grim - | wl-copy"
          "SHIFT, Print, exec, grim ~/Pictures/screenshot-$(date +'%Y-%m-%d-%H-%M-%S' ).png"
          "$mod SHIFT, Print, exec, slurp | grim -g - ~/Pictures/screenshot-slurp-$(date +'%Y-%m-%d-%H-%M-%S' ).png"

          # Resize mode
          "$mod, R, submap, resize"

          # Lock Screen
          "$mod SHIFT, O, exec, swaylock -fF"

          # Other keybindings
          "$mod SHIFT, R, exec, hyprctl reload"
          "$mod SHIFT, E, exec, hyprctl dispatch exit"
        ]
        # Workspaces 1-9
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = toString (i + 1);
            in
            [
              "$mod, ${ws}, workspace, ${ws}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
            ]
          ) 9
        ));

      exec-once = [
        "gnome-keyring-daemon --start --components=secrets"
        "1password --silent"
        "mako"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      ];
    };

    extraConfig = ''
    submap = resize
    binde = , H, resizeactive, -10 0
    binde = , J, resizeactive, 0 10
    binde = , K, resizeactive, 0 -10
    binde = , L, resizeactive, 10 0
    binde = , left, resizeactive, -10 0
    binde = , down, resizeactive, 0 10
    binde = , up, resizeactive, 0 -10
    binde = , right, resizeactive, 10 0
    bind = , escape, submap, reset
    submap = reset
    '';
  };
}
