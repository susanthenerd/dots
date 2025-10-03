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
    ./looking-glass-client.nix
    ./ghostty.nix
    ./kanshi.nix
    ./handlr-regex.nix
  ];
}
