{ ... }: {
  flake.homeModules.fuzzel = {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "emacs-terminal -e";
          fields = "filename,name,generic,exec";
        };
      };
    };
  };
}
