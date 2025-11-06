{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;

    settings = {
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      };
      commit = {
        gpgsign = true;
      };

      user = {
        email = "susan@susan.lol";
        name = "Susan";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINcre3PZxAV2Zt46k5NTegD4NgyzDnwrxFOr9g5vsUYr";
      };
    };
  };
}
