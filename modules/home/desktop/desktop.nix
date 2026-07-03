{ self, ... }:
{
  flake.homeModules.desktop = {
    imports = [
      self.homeModules.fuzzel
      self.homeModules.kanshi
      self.homeModules.i3wsr
      self.homeModules.i3statusRust
      self.homeModules.swayidle
      self.homeModules.swaylock
      self.homeModules.mako
      self.homeModules.sway
      self.homeModules.ghostty
      self.homeModules.xdg
      self.homeModules.keepassxc
      self.homeModules.gpg
    ];
  };
}
