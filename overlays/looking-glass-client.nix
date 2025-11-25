final: prev:
let
  gitCommitHash = "53bfb65";
  commitSrcHash = "sha256-SakFCEXPsJW3zmNpmklK8ZCGpcJzJ/4v7TJDpjWqVeA=";

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
