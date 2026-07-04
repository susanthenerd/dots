{...}: {
  flake.homeModules.gh = {pkgs, ...}: {
    programs.gh = {
      enable = true;
      extensions = [pkgs.gh-stack];
    };
  };
}
