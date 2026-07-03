{ ... }:
let
  laptop = "eDP-1";
  left = "LG Electronics LG ULTRAFINE 505NTEPHC988";
  right = "LG Electronics LG ULTRAFINE 505NTLEHC984";
  main = "LG Electronics LG ULTRAFINE 506NTFAHW667";
in
{
  flake.homeModules.kanshi = {
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
                criteria = left;
                scale = 1.0;
                position = "0,0";
                transform = "90";
                mode = "3840x2160@30Hz";
              }
              {
                criteria = main;
                scale = 1.0;
                position = "2160,0";
                transform = "270";
              }
              {
                criteria = right;
                scale = 1.0;
                transform = "270";
                position = "4320,0";
                mode = "3840x2160@30Hz";
              }
              {
                criteria = laptop;
                scale = 1.0;
                status = "disable";
                position = "6480,810";
              }
            ];
          };
        }
        {
          profile = {
            name = "docked-rotated";
            outputs = [
              {
                criteria = left;
                scale = 1.0;
                position = "0,0";
                transform = "90";
                mode = "3840x2160@30Hz";
              }
              {
                criteria = main;
                scale = 1.0;
                position = "2160,0";
                transform = "270";
              }
              {
                criteria = right;
                scale = 1.0;
                transform = "normal";
                position = "4320,810";
                mode = "3840x2160@30Hz";
              }
              {
                criteria = laptop;
                scale = 1.0;
                status = "disable";
                position = "8160,810";
              }
            ];
          };
        }
      ];
    };
  };
}
