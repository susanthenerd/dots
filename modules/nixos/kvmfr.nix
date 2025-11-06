{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.kvmfr;
in
{
  options.hardware.kvmfr = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable kvmfr (Looking Glass) kernel module and udev rule.";
    };

    staticSizeMB = lib.mkOption {
      type = lib.types.int;
      default = 128;
      description = "Static framebuffer size in MB for kvmfr module (static_size_mb).";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "kvm";
      description = "Group that owns /dev/kvmfr* devices via udev rule.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      initrd.kernelModules = [ "kvmfr" ];
      kernelModules = [ "kvmfr" ];
      extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
      extraModprobeConfig = ''
        options kvmfr static_size_mb=${toString cfg.staticSizeMB}
      '';
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="kvmfr", GROUP="${cfg.group}", MODE="0660"
    '';
  };
}
