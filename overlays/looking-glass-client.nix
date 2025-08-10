final: prev:
let
  gitCommitHash = "f15d72c";
  commitSrcHash = "sha256-UDSRL33nae5F/d2Bfoo52EytyiuWkwutXkSQD3n86/g=";

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
