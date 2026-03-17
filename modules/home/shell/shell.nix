{self, ...}: {
  flake.homeModules.shell = {pkgs, ...}: {
    imports = [
      self.homeModules.bat
      self.homeModules.eza
      self.homeModules.fish
      self.homeModules.fzf
      self.homeModules.gh
      self.homeModules.git
      self.homeModules.ssh
      self.homeModules.starship
      self.homeModules.yazi
      self.homeModules.zoxide
      self.homeModules.jujutsu
    ];

    home.packages = with pkgs; [
      mergiraf
    ];
  };
}
