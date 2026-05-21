{ ... }:
{
  flake.homeModules.cybesecurity =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ida-free
        ghidra
      ];
    };
}
