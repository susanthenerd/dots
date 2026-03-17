{...}: {
  flake.homeModules.eza = {
    programs.eza = {
      enable = true;
      git = true;
      icons = "auto";
    };
  };
}
