{...}: {
  flake.homeModules.keepassxc = {
    programs.keepassxc = {
      enable = true;
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
  };
}
