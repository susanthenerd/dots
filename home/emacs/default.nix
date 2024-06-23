{config, lib, pkgs, ... }:
let  
  myEmacs = pkgs.emacsWithPackagesFromUsePackage {                                      
    config = ./config.el;                                                               
    defaultInitFile = true;
    alwaysEnsure = true;
    package = pkgs.emacs29-pgtk;
    extraEmacsPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ];
  };  
in
{
  programs.emacs = {
    enable = true;
    package = myEmacs;
  };
  services.emacs = {
    enable = true;
    package = myEmacs;
    client.enable = true;
    defaultEditor = true;
  };
}
