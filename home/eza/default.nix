{ config, lib, pkgs, ... }:
{
  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
  };
}
