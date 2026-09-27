{ inputs, ... }:
{
  flake.homeModules.emacs =
    { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      claudeAgentAcp = inputs.llm-agents.packages.${system}.claude-agent-acp;
      codexAcp = inputs.llm-agents.packages.${system}.codex-acp;
      emacsPackage = pkgs.callPackage ../../../packages/emacs-configured.nix { };
      emacsTerminal = pkgs.writeShellScriptBin "emacs-terminal" ''
        set -eu

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

        exec "$emacsclient" -c --eval "$expr"
      '';
    in
    {
      services.emacs = {
        enable = true;
        package = emacsPackage;
        client.enable = true;
        socketActivation.enable = true;
      };

      home.packages = [
        emacsTerminal
        claudeAgentAcp
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
