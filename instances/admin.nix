{
  config,
  lib,
  pkgs,
  ...
}:
{
  instances.admin = {
    module = {
      name = "admin";
      input = "clan-core";
    };

    roles.default = {
      tags = [ "all" ];

      settings.allowedKeys = {
        susan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINcre3PZxAV2Zt46k5NTegD4NgyzDnwrxFOr9g5vsUYr";
      };
    };
  };
}
