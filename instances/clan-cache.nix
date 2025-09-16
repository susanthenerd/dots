{
  config,
  lib,
  pkgs,
  ...
}:
{
  instances.clan-cache = {
    module = {
      name = "trusted-nix-caches";
      input = "clan-core";
    };
    roles.default.tags = [ "all" ];
  };
}
