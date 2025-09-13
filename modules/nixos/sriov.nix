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

    enableGuc = lib.mkOption {
      type = lib.types.int;
      default = 3;
      description = "Enable GuC (Graphics micro Controller) with specified value.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

      extraModulePackages = [ pkgs.i915-sriov ];

      blacklistedKernelModules = [
        "xe"
      ];

      initrd.kernelModules = [ "i915" ];

      extraModprobeConfig = ''
        options i915 enable_guc=${toString cfg.enableGuc}
        options i915 max_vfs=${toString cfg.maxVfs}
      '';
    };

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:00:02.0",ATTR{sriov_numvfs}="${toString cfg.maxVfs}"
    '';
  };
}
