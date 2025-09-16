final: prev:
let
  gitCommitHash = "fddcb7f2";
  commitSrcHash = prev.lib.fakeHash;
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
