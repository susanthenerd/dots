{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostWsl
    ];
  };

  flake.nixosModules.hostWsl = {pkgs, ...}: {
    imports = [
      self.nixosModules.nixCommon
      inputs.nixos-wsl.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
    ];

    nixpkgs.hostPlatform = "x86_64-linux";

    wsl = {
      enable = true;
      defaultUser = "susan";
    };

    nixpkgs.overlays = [
      inputs.emacs-overlay.overlay
    ];
    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
        "https://cache.numtide.com"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };

    time.timeZone = "Europe/Bucharest";

    users = {
      mutableUsers = false;
      defaultUserShell = pkgs.fish;
      users.susan = {
        isNormalUser = true;
        extraGroups = ["wheel" "docker"];
        hashedPassword = "$6$vru/Kz/2RFnBeCXQ$FPDE/DET/P2pNfE2bpVsEdDCeMegmeMApE4l3m/2YR9t6qCSrdiTzqUr8aN1gnOTAcYXBQ30NUf3UtqxINmDL.";
      };
    };

    programs = {
      fish.enable = true;
      neovim.enable = true;
      git.enable = true;
      nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep 5 --keep-since 10d";
        };
        flake = "/home/susan/dots";
      };
      nix-ld.enable = true;
    };

    environment.systemPackages = with pkgs; [
      nixd
      nixfmt-rfc-style
      killall
    ];

    virtualisation.docker.enable = true;

    documentation.nixos.enable = false;
    system.stateVersion = "25.05";

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "bak";
      extraSpecialArgs = {
        inherit inputs;
        packages = self.packages.${pkgs.stdenv.hostPlatform.system};
      };
      users.susan = {
        imports = [
          self.homeModules.wsl
        ];
      };
      sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];
    };
  };
}
