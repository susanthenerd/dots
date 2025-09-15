{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "headscale.vps.susan.lol" = {
        extraConfig = ''
          reverse_proxy http://localhost:8080
        '';
      };
    };
  };
}
