{
  config,
  lib,
  pkgs,
  inputs,

  ...
}:
{
  imports = [
    ./fuzzel.nix
    ./sway.nix
    ./i3status-rust.nix
    ./mako.nix
    ./swayidle.nix
    ./swaylock.nix
    ./xdg.nix
    ./i3wsr.nix
  ];

  home.packages = with pkgs; [
    #kdePackages.dolphin
  ];
}
