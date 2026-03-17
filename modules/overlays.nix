{...}: {
  flake.overlays = {
    looking-glass = import ../overlays/looking-glass-client.nix;
    cmake = import ../overlays/cmake.nix;
    multiviewer = import ../overlays/multiviewer.nix;
  };
}
