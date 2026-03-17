{...}: {
  flake.homeModules.fish = {
    programs.fish = {
      enable = true;
      shellInit = ''
        set -g fish_greeting
      '';
    };
  };
}
