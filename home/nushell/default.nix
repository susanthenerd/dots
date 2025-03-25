{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs = {
    nushell = {
      enable = true;
    };
    carapace.enable = true;
    carapace.enableNushellIntegration = true;
  };
}
