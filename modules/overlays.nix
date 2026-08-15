{ ... }:

{
  flake.overlays = {
    waypipe = final: prev: {
      waypipe = prev.waypipe.override {
        ffmpeg_8 = final.ffmpeg_8;
      };
    };
    looking-glass = import ../overlays/looking-glass-client.nix;
    cmake = import ../overlays/cmake.nix;
    multiviewer = import ../overlays/multiviewer.nix;
    super-productivity = import ../overlays/super-productivity.nix;
  };
}
