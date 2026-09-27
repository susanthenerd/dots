{ ... }:
{
  flake.homeModules.personal =
    { pkgs, ... }:
    {
      programs.obs-studio.enable = true;

      home.packages = with pkgs; [
        prismlauncher
        signal-desktop
        libreoffice
        jetbrains.idea
      ];
    };
}
