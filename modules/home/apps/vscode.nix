{ ... }:
{
  flake.homeModules.vscode =
    { pkgs, ... }:
    {
      programs.cursor = {
        enable = true;
        package = (
          pkgs.vscode-with-extensions.override {
            vscode = pkgs.code-cursor;
            vscodeExtensions = with pkgs.vscode-marketplace; [
              # ms-python.python
              jnoortheen.nix-ide
              monokai.theme-monokai-pro-vscode
              # ms-python.debugpy
              # ms-python.vscode-python-envs
              # ms-toolsai.jupyter
              # ms-toolsai.jupyter-keymap
              # ms-toolsai.jupyter-renderers
              # ms-toolsai.vscode-jupyter-slideshow
              # ms-toolsai.vscode-jupyter-cell-tags
              mkhl.direnv
              mechatroner.rainbow-csv
              jakebecker.elixir-ls
              charliermarsh.ruff
              astral-sh.ty
              phoenixframework.phoenix
              mathematic.vscode-pdf 	
              bradlc.vscode-tailwindcss
              tekumara.typos-vscode
              remoteoss.dexter-lsp
              expertlsp.expert
              hashicorp.terraform
              openai.chatgpt
            ];
          }
        );
      };
    };
}
