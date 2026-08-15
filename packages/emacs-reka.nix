{
  emacsPackage,
  libxkbcommon,
  pkg-config,
  rustPlatform,
  src,
}:

let
  module = rustPlatform.buildRustPackage {
    pname = "libreka";
    version = "0.1.0";
    inherit src;

    cargoLock.lockFile = src + "/Cargo.lock";
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [
      emacsPackage
      libxkbcommon
    ];

    postInstall = ''
      mkdir -p "$out/share/emacs/site-lisp"
      ln -s "$out/lib/libreka.so" "$out/share/emacs/site-lisp/libreka.so"
    '';
  };
in
emacsPackage.pkgs.trivialBuild {
  pname = "reka";
  version = "0.1.0";
  inherit src;
  sourceRoot = "source/lisp";
  packageRequires = [ module ];
}
