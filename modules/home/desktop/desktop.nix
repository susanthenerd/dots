{self, ...}: {
  flake.homeModules.desktop = {
    imports = [
      self.homeModules.sway
      self.homeModules.ghostty
      self.homeModules.fuzzel
      self.homeModules.mako
      self.homeModules.kanshi
      self.homeModules.swayidle
      self.homeModules.swaylock
      self.homeModules.i3statusRust
      self.homeModules.i3wsr
      self.homeModules.swayEasyfocus
      self.homeModules.xdg
      self.homeModules.keepassxc
      self.homeModules.gpg
      self.homeModules.handlrRegex
      self.homeModules.lookingGlassClient
    ];
  };
}
