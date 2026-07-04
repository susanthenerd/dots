{ self, ... }:
{
  flake.homeModules.desktop = {
    imports = [
      self.homeModules.fuzzel
      self.homeModules.kanshi
      self.homeModules.mako
      self.homeModules.xdg
      self.homeModules.keepassxc
      self.homeModules.gpg
    ];
  };
}
