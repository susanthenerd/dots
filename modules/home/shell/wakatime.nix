{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      wakatime-cli
    ]
    ++ (with inputs.terminal-wakatime.packages.${pkgs.system}; [
      default
    ]);

  sops.secrets.wakatime-api-key = { };

  home.file.".wakatime.cfg".source = (pkgs.formats.ini { }).generate ".wakatime.cfg" {
    settings = {
      api_url = "https://hackatime.hackclub.com/api/hackatime/v1";
      api_key = "260dddb8-cb87-4ae7-90c0-419de8128eb9";
    };
  };
}
