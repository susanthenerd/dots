{ ... }:
{
  flake.homeModules.waybar =
    { pkgs, ... }:
    {
      programs.waybar = {
        enable = true;
        systemd = {
          enable = true;
          targets = [ "mango-session.target" ];
        };
        settings.main = {
          layer = "top";
          position = "bottom";
          height = 28;
          spacing = 4;

          modules-left = [
            "dwl/tags"
            "dwl/window"
          ];
          modules-right = [
            "mpris"
            "memory"
            "cpu"
            "battery"
            "network"
            "pulseaudio"
            "backlight"
            "clock"
            "tray"
          ];

          "dwl/tags" = {
            num-tags = 9;
            tag-labels = [
              "1"
              "2"
              "3"
              "4"
              "5"
              "6"
              "7"
              "8"
              "9"
            ];
          };

          "dwl/window" = {
            format = "{title}";
            max-length = 80;
          };

          mpris = {
            format = "{player_icon} {dynamic}";
            format-paused = "{status_icon} {dynamic}";
            dynamic-len = 20;
            player-icons.default = "play";
            status-icons.paused = "pause";
          };

          memory = {
            interval = 5;
            format = "mem {percentage}%";
          };

          cpu = {
            interval = 5;
            format = "cpu {usage}%";
          };

          battery = {
            format = "bat {capacity}%";
            format-charging = "chg {capacity}%";
          };

          network = {
            interval = 5;
            format-wifi = "net {bandwidthDownBytes} {bandwidthUpBytes}";
            format-ethernet = "net {bandwidthDownBytes} {bandwidthUpBytes}";
            format-disconnected = "net down";
            tooltip-format-wifi = "{essid} {signalStrength}% {ipaddr}";
            tooltip-format-ethernet = "{ifname} {ipaddr}";
          };

          pulseaudio = {
            format = "vol {volume}%";
            format-muted = "vol muted";
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          };

          backlight = {
            format = "brt {percent}%";
          };

          clock = {
            interval = 60;
            format = "{:%a %d/%m %R}";
          };

          tray = {
            icon-size = 16;
            spacing = 6;
          };
        };

        style = ''
          * {
            border: none;
            border-radius: 0;
            font-family: "RecMonoDuotone Nerd Font Mono", "FontAwesome", monospace;
            font-size: 14px;
            min-height: 0;
          }

          window#waybar {
            background: #282828;
            color: #ebdbb2;
          }

          #tags button {
            color: #a89984;
            padding: 0 6px;
          }

          #tags button.focused {
            background: #504945;
            color: #fbf1c7;
          }

          #tags button.urgent {
            background: #cc241d;
            color: #fbf1c7;
          }

          #window,
          #mpris,
          #memory,
          #cpu,
          #battery,
          #network,
          #pulseaudio,
          #backlight,
          #clock,
          #tray {
            padding: 0 8px;
          }

          #battery.warning {
            color: #fabd2f;
          }

          #battery.critical {
            color: #fb4934;
          }
        '';
      };
    };
}
