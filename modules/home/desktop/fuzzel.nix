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
        terminal = "ghostty -e";
        fields = "filename, name, generic, exec";
      };
    };
  };
}
