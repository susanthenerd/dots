{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "susan@susan.lol";
        name = "Susan";
      };

      pager = {
        paginate = "never";
      };

      signing = {
        behavior = "own";
        backend = "ssh";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINcre3PZxAV2Zt46k5NTegD4NgyzDnwrxFOr9g5vsUYr";
        backends.ssh.program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      };

      git = {
        sign-on-push = true;
      };
    };
  };
}
