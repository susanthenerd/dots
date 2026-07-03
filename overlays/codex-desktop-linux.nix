{ inputs }:

final: prev:
let
  system = final.stdenv.hostPlatform.system;
  codexPackages = inputs.codex-desktop-linux.packages.${system};
  schemaDataDirs = [
    "${final.gtk3}/share/gsettings-schemas/${final.gtk3.name}"
    "${final.gsettings-desktop-schemas}/share/gsettings-schemas/${final.gsettings-desktop-schemas.name}"
  ];
  xdgDataDirArgs = final.lib.concatMap (path: [
    "--prefix"
    "XDG_DATA_DIRS"
    ":"
    path
  ]) schemaDataDirs;
  wrapCodexDesktop = name:
    let
      base = codexPackages.${name};
    in
    final.symlinkJoin {
      name = "${base.name}-gsettings";
      paths = [ base ];
      nativeBuildInputs = [ final.makeWrapper ];
      postBuild = ''
        if [ -e "$out/bin/codex-desktop" ]; then
          rm -f "$out/bin/codex-desktop"
          makeWrapper "${base}/bin/codex-desktop" "$out/bin/codex-desktop" ${final.lib.escapeShellArgs xdgDataDirArgs}
        fi

        desktopFile="$out/share/applications/codex-desktop.desktop"
        if [ -e "$desktopFile" ]; then
          target="$(readlink -f "$desktopFile")"
          rm -f "$desktopFile"
          substitute "$target" "$desktopFile" \
            --replace-fail "${base}/bin/codex-desktop" "$out/bin/codex-desktop"
        fi
      '';
      meta = base.meta or { };
    };
in
{
  codex-desktop = wrapCodexDesktop "codex-desktop";
  codex-desktop-computer-use-ui = wrapCodexDesktop "codex-desktop-computer-use-ui";
  codex-desktop-remote-mobile-control = wrapCodexDesktop "codex-desktop-remote-mobile-control";
  codex-desktop-computer-use-ui-remote-mobile-control =
    wrapCodexDesktop "codex-desktop-computer-use-ui-remote-mobile-control";
}
