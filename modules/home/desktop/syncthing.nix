{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        pixel = {
          id = "J7AOCRC-634GCPL-EXCXXJL-LHMGS6K-37UWV2Q-GW3YCFR-LAOKB6I-CTXSRAS";
          addresses = [
            "tcp://pixel.tailnet.susan.lol:22000"
          ];
        };
      };

      folders = {
        "~/Pictures" = {
          devices = [ "pixel" ];
        };

      };
    };
  };
}
