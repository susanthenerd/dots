{ inputs, ... }:
{
  flake.homeModules.emacs =
    { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      codexAcp = inputs.llm-agents.packages.${system}.codex-acp;
      emacsPackage = pkgs.callPackage ../../../packages/emacs-configured.nix {
        emacsSrc = inputs.emacs-pwayland;
      };
      emacsTerminal = pkgs.writeShellScriptBin "emacs-terminal" ''
        set -eu

        emacs=${emacsPackage}/bin/emacs
        emacsclient=${emacsPackage}/bin/emacsclient

        escape_lisp_string() {
          printf '%s' "$1" | ${pkgs.gnused}/bin/sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
        }

        if [ "''${1-}" = "-e" ]; then
          shift
          argv="'("
          for arg in "$@"; do
            escaped=$(escape_lisp_string "$arg")
            argv="$argv \"$escaped\""
          done
          argv="$argv)"
          expr="(progn (require 'ghostel) (susan/ghostel-exec $argv))"
        else
          expr="(progn (require 'ghostel) (ghostel t))"
        fi

        if "$emacsclient" --eval t >/dev/null 2>&1; then
          exec "$emacsclient" -c --eval "$expr"
        fi

        exec "$emacs" --eval "$expr"
      '';
    in
    {
      programs.emacs = {
        enable = true;
        package = emacsPackage;
      };

      services.emacs.enable = false;

      home.packages = [
        emacsTerminal
        codexAcp
        pkgs.clang-tools
        pkgs.elixir-ls
        pkgs.nixd
        pkgs.nixfmt
        pkgs.rust-analyzer
        pkgs.typescript
        pkgs.typescript-language-server
      ];
    };
}
