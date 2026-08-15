{
  autoconf,
  automake,
  emacs-git,
  emacsSrc,
  fontconfig,
  freetype,
  giflib,
  lib,
  libepoxy,
  libjpeg,
  libpng,
  librsvg,
  libtiff,
  libxkbcommon,
  skia,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

let
  emacsBase = emacs-git.override {
    withX = false;
    withCairo = false;
    withGTK3 = false;
    withPgtk = false;
    withXwidgets = false;
    withToolkitScrollBars = false;
  };
in
emacsBase.overrideAttrs (old: {
  src = emacsSrc;

  patches = lib.filter (
    patch:
    !lib.hasSuffix "-nullify-read-symbol-shorthands-around-risky-intern-calls-80574.patch" (
      toString patch
    )
  ) (old.patches or [ ]);

  configureFlags =
    lib.filter (
      flag:
      !lib.elem flag [
        "--without-gif"
        "--without-jpeg"
        "--without-png"
        "--without-tiff"
      ]
    ) (old.configureFlags or [ ])
    ++ [
      "--with-rsvg"
      "--with-pwayl"
      "--with-skia"
      "--with-gif"
      "--with-jpeg"
      "--with-png"
      "--with-tiff"
    ];

  buildInputs = (old.buildInputs or [ ]) ++ [
    fontconfig
    freetype
    giflib
    libjpeg
    libpng
    libtiff
    librsvg
    skia
    libepoxy
    wayland
    wayland-protocols
    libxkbcommon
  ];

  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
    autoconf
    automake
    wayland-scanner
  ];

  preConfigure = (old.preConfigure or "") + ''
    ./autogen.sh
  '';
})
