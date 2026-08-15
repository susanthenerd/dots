{
  pkgs,
  emacsSrc,
  configPath ? ../modules/home/emacs/config.el,
  extraEmacsPackages ? (_: [ ]),
}:

let
  emacsPackage = pkgs.callPackage ./emacs-pwayland-skia.nix { inherit emacsSrc; };

  treeSitterGrammars =
    let
      grammars = with pkgs.tree-sitter-grammars; {
        c = tree-sitter-c;
        cpp = tree-sitter-cpp;
        elixir = tree-sitter-elixir;
        heex = tree-sitter-heex;
        javascript = tree-sitter-javascript;
        nix = tree-sitter-nix;
        rust = tree-sitter-rust;
        tsx = tree-sitter-tsx;
        typescript = tree-sitter-typescript;
      };
    in
    pkgs.runCommand "emacs-treesit-grammars" { } ''
      mkdir -p "$out"
      ${pkgs.lib.concatStringsSep "\n" (
        pkgs.lib.mapAttrsToList (
          language: grammar: ''ln -s "${grammar}/parser" "$out/libtree-sitter-${language}.so"''
        ) grammars
      )}
    '';
in
pkgs.emacsWithPackagesFromUsePackage {
  config = configPath;
  defaultInitFile = true;
  alwaysEnsure = true;
  package = emacsPackage;
  override = self: _super: {
    ghostel = self.callPackage ./emacs-ghostel.nix { };
    susan-treesit-grammars = self.trivialBuild {
      pname = "susan-treesit-grammars";
      version = "0-unstable";
      src = pkgs.writeText "susan-treesit-grammars.el" ''
        (require 'treesit)
        (add-to-list 'treesit-extra-load-path "${treeSitterGrammars}")
        (provide 'susan-treesit-grammars)
      '';
    };
  };
  extraEmacsPackages =
    epkgs:
    [
      epkgs.eldoc
      epkgs.flymake
      epkgs.project
      epkgs.susan-treesit-grammars
      epkgs.xref
    ]
    ++ extraEmacsPackages epkgs;
}
