{ config, lib, pkgs, ... }:
{
  programs.foot = {
    enable = true;
    server.enable = true;

    settings = {
      main = {
        font = "Rec Mono Duotone Nerd Font:size=16";
      };
    };
  };
}
