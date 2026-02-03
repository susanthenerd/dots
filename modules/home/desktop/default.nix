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
    ./sway-easyfocus.nix
    ./xdg.nix
    ./i3wsr.nix
    ./looking-glass-client.nix
    ./ghostty.nix
    ./kanshi.nix
    ./handlr-regex.nix
    ./keepassxc.nix
    ./gpg.nix
  ];
}
