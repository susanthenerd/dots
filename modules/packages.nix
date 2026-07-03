{inputs, self, ...}: {
  perSystem = {pkgs, system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [
        self.overlays.codex-desktop-linux
        self.overlays.looking-glass
        self.overlays.cmake
        inputs.emacs-overlay.overlay
        self.overlays.multiviewer
        inputs.nix-vscode-extensions.overlays.default
      ];
      config = {
        allowUnfree = true;
      };
    };

    packages = {
      pano-scrobbler = pkgs.callPackage ../packages/pano-scrobbler.nix {};
      jackbox-utility = pkgs.callPackage ../packages/jackbox-utility.nix {};
      t3code = pkgs.callPackage ../packages/t3code.nix {};
    };
  };
}
