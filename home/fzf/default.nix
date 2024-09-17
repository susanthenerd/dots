{config, lib, pkgs, ...}:{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
}
