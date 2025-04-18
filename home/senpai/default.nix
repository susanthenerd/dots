{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.senpai = {
    enable = true;
    config = {
      address = "chat.sr.ht:6697";
      nickname = "cristiioan";
      password-cmd = [
        "op"
        "read"
        "op://Personal/irc bouncer chat.sr.ht/credential"
      ];
    };
  };
}