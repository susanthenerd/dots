{ config, lib, pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 14;
        normal = {
          family = "Rec Mono Duotone Nerd Font";
          style = "Regular";
        };
      };
    };
  };
}
