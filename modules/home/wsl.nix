{
  self,
  inputs,
  ...
}: {
  flake.homeModules.wsl = {pkgs, packages, ...}: {
    imports = [
      self.homeModules.shell
      self.homeModules.emacs
    ];

    home = {
      username = "susan";
      homeDirectory = "/home/susan";

      packages =
        (with pkgs; [
          gdb
          cmake
          wget
          unzip
          age
          sops
          devenv
          btop
          gcc
        ])
        ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
          opencode
          codex
          claude-code
          gemini-cli
        ]);

      stateVersion = "24.11";
      shell.enableFishIntegration = true;
    };

    programs = {
      home-manager.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      ripgrep.enable = true;
    };

    sops = {
      defaultSopsFile = ../../secrets/xps.yaml;
      age.keyFile = "/home/susan/.config/sops/age/keys.txt";
    };
  };
}
