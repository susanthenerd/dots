{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.keepassxc = {
    enable = true;
    # autostart = true;
    settings = {
      Browser = {
        Enabled = true;
        UpdateBinaryPath = false;
      };

      GUI = {
        AdvancedSettings = true;
        MinimizeToTray = true;
        MinimizeOnStartup = true;
        MinimizeOnClose = true;
        ShowTrayIcon = true;
      };
    };
  };
}
