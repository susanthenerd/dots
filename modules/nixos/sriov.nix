{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.graphics.sriov;
in
{
  options.hardware.graphics.sriov = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Intel i915 SR-IOV support (uses custom kernel and module).";
    };

    maxVfs = lib.mkOption {
      type = lib.types.int;
      default = 7;
      description = "Maximum number of virtual functions to create.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

      extraModulePackages = [ pkgs.xe-sriov ];

      blacklistedKernelModules = [
        "xe"
        "i915"
      ];

      initrd.kernelModules = [ "xe" ];

      extraModprobeConfig = ''
        options xe max_vfs=${toString cfg.maxVfs}
      '';
    };

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:00:02.0",ATTR{sriov_numvfs}="${toString cfg.maxVfs}"
    '';
  };
}
