{
  config,
  lib,
  pkgs,
  ...
}:

let
  domain = "headscale.vps.susan.lol";
in
{
  services = {
    headscale = {
      enable = true;
      settings = {
        address = "0.0.0.0";
        port = 8080;
        server_url = "https://${domain}";
        dns = {
          base_domain = "tailnet.susan.lol";
          nameservers.global = [
            "1.1.1.1"
            "1.0.0.1"
          ];
        };
      };
    };

    caddy = {
      enable = true;
      virtualHosts = {
        "${domain}" = {
          extraConfig = ''
            reverse_proxy http://localhost:${toString config.services.headscale.port}
          '';
        };
      };
    };
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
