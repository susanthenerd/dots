final: prev:
let
  version = "9.20.0";
in
{
  todoist-electron = prev.todoist-electron.overrideAttrs (oldAttrs: {
    inherit version;

    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
      final.buildPackages.makeWrapper
    ];

    src = prev.fetchurl {
      url = "https://electron-dl.todoist.net/linux/Todoist-linux-${version}-x86_64-latest.AppImage";
      hash = "sha256-Rpn7cobgYQt06d+t5XDYUZTOc/pnpRJIEXZeDAiJIH8=";
    };

    extraInstallCommands = (oldAttrs.extraInstallCommands or "") + ''
      . ${prev.makeWrapper}/nix-support/setup-hook
      wrapProgram $out/bin/todoist-electron \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    '';
  });
}
