{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./bat.nix
    ./eza.nix
    ./fish.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./ssh.nix
    ./starship.nix
    ./yazi.nix
    ./zoxide.nix
    ./jujutsu.nix
  ];

  home.packages = with pkgs; [
    mergiraf
  ];
}
