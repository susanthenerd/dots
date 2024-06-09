{ config, lib, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [
          "eDP-1"
        ];
        modules-left = [ "hyprland/workspaces" "hyprland/title" ];
        modules-center = [ ];
        modules-right = [ "temperature" "soundr" ];
      };


    };
  };
}
