{ ... }:
{
  flake.homeModules.vscode =
    { pkgs, ... }:
    {
      programs.vscode = {
        enable = true;
        package = (
          pkgs.vscode-with-extensions.override {
            vscode = pkgs.vscodium;
            vscodeExtensions = with pkgs.vscode-marketplace; [
              ms-python.python
              jnoortheen.nix-ide
              monokai.theme-monokai-pro-vscode
              ms-python.debugpy
              ms-python.vscode-python-envs
              ms-toolsai.jupyter
              ms-toolsai.jupyter-keymap
              ms-toolsai.jupyter-renderers
              ms-toolsai.vscode-jupyter-slideshow
              ms-toolsai.vscode-jupyter-cell-tags
              mkhl.direnv
              mechatroner.rainbow-csv
              jakebecker.elixir-ls
              charliermarsh.ruff
              astral-sh.ty
              phoenixframework.phoenix
              mathematic.vscode-pdf 	
              
            ];
          }
        );
      };
    };
}
