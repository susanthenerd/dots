{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    looking-glass-client
  ];

  xdg.configFile."looking-glass/config.ini".source = (pkgs.formats.ini { }).generate "config.ini" {
    egl.vsync = "on";
    opengl.vsync = "on";
  };
}
