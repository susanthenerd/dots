{...}: {
  flake.homeModules.jujutsu = {
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

        git = {
          sign-on-push = true;
        };
      };
    };
  };
}
