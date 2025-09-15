{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.traefik = {
    enable = true;
  };
}
