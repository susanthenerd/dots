{inputs, self, ...}: {
  perSystem = {pkgs, system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [
        self.overlays.looking-glass
        self.overlays.cmake
        inputs.emacs-overlay.overlay
        self.overlays.multiviewer
      ];
      config = {
        allowUnfree = true;
      };
    };

    packages = {
      pano-scrobbler = pkgs.callPackage ../packages/pano-scrobbler.nix {};
      jackbox-utility = pkgs.callPackage ../packages/jackbox-utility.nix {};
    };
  };
}
