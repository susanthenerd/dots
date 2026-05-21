{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "t3code";
  version = "0.0.22";

  src = fetchurl {
    url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
    hash = "sha256-JUlF9G6KkvOy550HwndsnfYQBUlReRWCJUe6cqx/9Xc=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/t3code.desktop \
      $out/share/applications/t3code.desktop
    substituteInPlace $out/share/applications/t3code.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=t3code %U'

    install -Dm444 ${appimageContents}/usr/share/icons/hicolor/1024x1024/apps/t3code.png \
      $out/share/icons/hicolor/1024x1024/apps/t3code.png
  '';

  meta = {
    description = "Minimal GUI for coding agents";
    homepage = "https://github.com/pingdotgg/t3code";
    downloadPage = "https://github.com/pingdotgg/t3code/releases";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
