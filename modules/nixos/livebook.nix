{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.livebook = {
    enableUserService = false;
    environment = {
      LIVEBOOK_TOKEN_ENABLED = false;
    };
  };
}
