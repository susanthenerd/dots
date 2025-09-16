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
          reverse_proxy http://127.0.0.1:8080
        '';
      };
    };
  };
}
