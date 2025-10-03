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
  right = "LG Electronics LG ULTRAFINE 506NTFAHW667";
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
              # right monitor vertical
              criteria = right;
              scale = 1.0;
              transform = "270";
              position = "6000,0";
            }
            {
              # laptop monitor
              criteria = laptop;
              scale = 1.0;
              position = "8160,810";
            }
          ];
        };
      }
    ];
  };
}
