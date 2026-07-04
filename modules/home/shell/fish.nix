{ ... }:
{
  flake.homeModules.fish =
    { pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        shellInit = ''
          set -g fish_greeting
          source ${pkgs.ewm}/etc/emacs-ewm.fish
        '';
      };
    };
}
