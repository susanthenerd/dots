{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        theme = "gruvbox-dark";
        icons = "material-nf";
        blocks = [
          {
            block = "music";
            format = " $icon {$combo.str(max_w:20,rot_interval:0.5) $play $next |}";
            format_alt = " $icon ";
            click = [
              {
                button = "back";
                action = "seek_backward";
              }
              {
                button = "forward";
                action = "seek_forward";
              }
              {
                button = "down";
                action = "volume_down";
              }
              {
                button = "up";
                action = "volume_up";
              }
              {
                button = "middle";
                widget = ".";
                action = "toggle_format";
              }
            ];
          }
          {
            block = "memory";
          }
          {
            block = "cpu";
          }
          {
            block = "battery";
          }
          {
            block = "net";
            format = "$icon ^icon_net_down$speed_down.eng(prefix:M) ^icon_net_up$speed_up.eng(prefix:M)";
            format_alt = "$icon {$signal_strength $ssid $frequency|Wired connection} $ip";
          }
          {
            block = "sound";
          }
          {
            block = "backlight";
            invert_icons = true;
            format = "$icon $brightness";
          }
          {
            block = "time";
            format = "$timestamp.datetime(f:'%a %d/%m %R') ";
            interval = 60;
          }
        ];
      };
    };
  };
}
