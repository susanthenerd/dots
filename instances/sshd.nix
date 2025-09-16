{
  config,
  lib,
  pkgs,
  ...
}:
{
  instances.sshd = {
    module = {
      name = "sshd";
      input = "clan-core";
    };

    roles.server.tags = [ "all" ];
    roles.client.tags = [ "all" ];
  };
}
