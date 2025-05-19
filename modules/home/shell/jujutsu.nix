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
    };
  };
}
