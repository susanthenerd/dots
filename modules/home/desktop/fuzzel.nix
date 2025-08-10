{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "ghostty";
        fields = "filename, name, generic, exec";
      };
    };
  };
}
