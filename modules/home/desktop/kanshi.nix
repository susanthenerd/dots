{...}: let
  laptop = "eDP-1";
  main = "LG Electronics LG ULTRAFINE 505NTEPHC988";
  left = "LG Electronics LG ULTRAFINE 505NTLEHC984";
  right = "LG Electronics LG ULTRAFINE 506NTFAHW667";
in {
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
              }
              {
                criteria = main;
                scale = 1.0;
                position = "2160,810";
              }
              {
                criteria = right;
                scale = 1.0;
                transform = "270";
                position = "6000,0";
              }
              {
                criteria = laptop;
                scale = 1.0;
                position = "8160,810";
              }
            ];
          };
        }
      ];
    };
  };
}
