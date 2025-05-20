{
  config,
  lib,
  pkgs,
  ...
}:
{
  wayland.desktopManager.cosmic = {
    enable = false;
  };
}
