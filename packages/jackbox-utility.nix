{
  lib,
  flutter338,
  fetchFromGitHub,
  gst_all_1,
  jdk17_headless,
  libunwind,
  orc,
  symlinkJoin,
  zlib,
}:

let
  zlibCmakeRoot = symlinkJoin {
    name = "jackbox-utility-zlib-cmake-root";
    paths = [
      (lib.getDev zlib)
      (lib.getLib zlib)
    ];
  };
in
flutter338.buildFlutterApplication rec {
  pname = "jackbox-utility";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "JackboxUtility";
    repo = "JackboxUtility";
    tag = version;
    hash = "sha256-fjvIwtgKBrEruEVo2TH7lbR8crm36CuTNI4kuGjJXjE=";
  };

  sourceRoot = "${src.name}/jackbox_patcher";

  pubspecLock = lib.importJSON ./jackbox-utility-pubspec.lock.json;

  flutterBuildFlags = [
    "--target"
    "lib/main_release.dart"
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    # jni is a transitive dependency from Flutter plugins used by the app.
    jdk17_headless
    libunwind
    orc
    zlib
  ];

  # sentry_flutter's crashpad uses cmake find_package(ZLIB) which needs
  # a prefix containing both headers and libraries in the Nix sandbox
  env = {
    ZLIB_ROOT = zlibCmakeRoot;
  };

  gitHashes = {
    dart_discord_rpc = "sha256-YYQ9BRFgq5FSLLb+AIzH1q09RKNwKuhTH2TN4MTkfhQ=";
  };

  meta = {
    description = "Utility for patching and launching Jackbox Party Pack games";
    homepage = "https://github.com/JackboxUtility/JackboxUtility";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "JackboxUtility";
  };
}
