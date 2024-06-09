{ config, lib, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;


    settings = {
      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$menu" = "wofi --show drun";

      general = {
        gaps_in = 5;
        gaps_out = 5;

        resize_on_border = true;
        layout = "master";
      };

      decoration = {
        rounding = 5;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;

          vibrancy = 0.1696;
        };
      };

      master = {
        new_is_master = false;
      };

      misc = {
        disable_hyprland_logo = false;
      };

      input = {
        kb_layout = "us";

        touchpad = {
          natural_scroll = true;
        };
      };

      gestures = {
        workspace_swipe = true;
      };

      monitor = ",preferred,auto,1";

      exec-once = [ "gnome-keyring-daemon --start --components=secrets" ];

      bind = [
        "$mod, RETURN, exec, $terminal"
        "$mod SHIFT, RETURN, exec, $menu"
        "$mod SHIFT, c, killactive,"
        "$mod SHIFT, r, exec, hyprctl reload"
        "$mod, SPACE, togglefloating,"
        "$mod SHIFT, SPACE, togglesplit,"
        "$mod SHIFT, e, exit,"
        "$mod SHIFT, u, exec, pidof hyprlock || hyprlock"

        # Full screen
        "$mod, f, fullscreen, "
        "$mod SHIFT, f, fakefullscreen,"

        # Move focus
        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"


        # Workspace switch
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 0"

        # Move to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 0"

        # Move to workspace silent
        "$mod CTRL SHIFT, 1, movetoworkspacesilent, 1"
        "$mod CTRL SHIFT, 2, movetoworkspacesilent, 2"
        "$mod CTRL SHIFT, 3, movetoworkspacesilent, 3"
        "$mod CTRL SHIFT, 4, movetoworkspacesilent, 4"
        "$mod CTRL SHIFT, 5, movetoworkspacesilent, 5"
        "$mod CTRL SHIFT, 6, movetoworkspacesilent, 6"
        "$mod CTRL SHIFT, 7, movetoworkspacesilent, 7"
        "$mod CTRL SHIFT, 8, movetoworkspacesilent, 8"
        "$mod CTRL SHIFT, 9, movetoworkspacesilent, 9"
        "$mod CTRL SHIFT, 0, movetoworkspacesilent, 0"
      ];
    };
  };
}

