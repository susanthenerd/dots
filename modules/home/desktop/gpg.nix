{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.gpg = {
    enable = true;

    scdaemonSettings = {
      disable-ccid = true;
      reader-port = "Yubico Yubi";
    };
  };

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
    enableSshSupport = true;
    sshKeys = [ "B2DEFF8DA65BBADA601D1836AC7D38C0F846AA03" ];
    pinentry = {
      package = pkgs.pinentry-qt;
      program = "pinentry";
    };
  };

}
