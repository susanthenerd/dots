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
        terminal = "${pkgs.alacritty}/bin/alacritty";
        fields = "filename, name, generic, exec";
      };
    };
  };
}
