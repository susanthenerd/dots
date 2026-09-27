{inputs, ...}: {
  options = {
    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
      homeModules = inputs.nixpkgs.lib.mkOption {
        default = {};
      };
      diskoConfigurations = inputs.nixpkgs.lib.mkOption {
        type = inputs.nixpkgs.lib.types.lazyAttrsOf inputs.nixpkgs.lib.types.raw;
        default = {};
      };
    };
  };

  config = {
    systems = ["x86_64-linux"];
  };
}
