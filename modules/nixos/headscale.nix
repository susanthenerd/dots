{
  config,
  lib,
  pkgs,
  ...
}:
{
  services = {
    headscale = {
      enable = true;
      settings = {
        address = "0.0.0.0";
        port = 8080;
        server_url = "https://headscale.vps.susan.lol";
        dns = {
          base_domain = "tailnet.susan.lol";
          nameservers.global = [
            "1.1.1.1"
            "1.0.0.1"
          ];
        };
      };
    };
  };
}
