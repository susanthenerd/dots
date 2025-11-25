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
        backend = "gpg";
      };

      git = {
        sign-on-push = true;
      };
    };
  };
}
