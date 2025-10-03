final: prev:
let
  gitCommitHash = "fddcb7f";
  commitSrcHash = "sha256-e5Lvzbj+i5U70/NH73CYFIen44hjNIyT+S7dy4yS5/0=";

in
{
  looking-glass-client = prev.looking-glass-client.overrideAttrs (oldAttrs: {
    version = gitCommitHash;

    src = oldAttrs.src.override {
      inherit (oldAttrs.src) owner repo;
      rev = gitCommitHash;
      hash = commitSrcHash;

      fetchSubmodules = true;
    };
  });
}
