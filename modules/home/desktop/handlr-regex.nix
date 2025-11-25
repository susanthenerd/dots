{
  confib,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.handlr-regex ];

  xdg.desktopEntries."handlr-dispatcher" = {
    name = "Handlr Dispatcher";
    comment = "Route links via handlr-regex";
    exec = "${pkgs.handlr-regex}/bin/handlr open %u";
    terminal = false;
    type = "Application";
    noDisplay = true;
    mimeType = [
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
  };

  xdg.configFile."handlr/handlr.toml".source = (pkgs.formats.toml { }).generate "handlr.toml" {
    handlers = [
      {
        exec = "${pkgs.firefox}/bin/firefox %u";
        terminal = false;
        regexes = [ ".*" ];
      }
    ];
  };
}
