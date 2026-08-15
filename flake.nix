{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm-nix = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-super-productivity-pr.url =
      "github:NixOS/nixpkgs/pull/527809/head";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    reka = {
      url = "git+https://codeberg.org/tazjin/reka";
      flake = false;
    };

    emacs-pwayland = {
      url = "git+https://codeberg.org/ezemtsov/emacs.git?ref=refs/heads/wayland&shallow=1";
      flake = false;
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };

    pano-scrobbler-flake = {
      url = "github:kawaiiDango/pano-scrobbler-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
    deploy-rs.url = "github:serokell/deploy-rs";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
