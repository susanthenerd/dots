{config, lib, pkgs, ...}:{
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
