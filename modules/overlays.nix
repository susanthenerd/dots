{ inputs, lib, ... }:

{
  flake.overlays = {
    codex-desktop-linux = import ../overlays/codex-desktop-linux.nix { inherit inputs; };
    looking-glass = import ../overlays/looking-glass-client.nix;
    cmake = import ../overlays/cmake.nix;
    multiviewer = import ../overlays/multiviewer.nix;
    super-productivity = import ../overlays/super-productivity.nix;
  };
}
