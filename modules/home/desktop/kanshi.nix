{
  config,
  lib,
  pkgs,
  ...
}:
let
  laptop = "eDP-1";
  main = "LG Electronics LG ULTRAFINE 505NTEPHC988";
  left = "LG Electronics LG ULTRAFINE 505NTLEHC984";
in
{
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "default";
          outputs = [
            {
              criteria = laptop;
              scale = 1.0;
            }
          ];
        };
      }
      {
        profile = {
          name = "docked";
          outputs = [
            {
              # left monitor vertical
              criteria = left;
              scale = 1.0;
              position = "0,0";
              transform = "90";
            }
            {
              # main monitor
              criteria = main;
              scale = 1.0;
              position = "2160,810";
            }
            {
              # laptop monitor
              criteria = laptop;
              scale = 1.25;
              position = "6000,1120";
            }
          ];
        };
      }
    ];
  };
}
