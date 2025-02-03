{ config, lib, pkgs, stdenv, kmod, ... }:

let
  i915SriovDkms = config.boot.kernelPackages.callPackage ./package.nix {};
in
{
  options.hardware.graphics.i915-sriov-dkms = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable the experimental i915 SR-IOV DKMS module along with host configuration.
        (This module should be installed both on the host and on any Linux guests.)
      '';
    };

    # PCI address of your iGPU; adjust if your device is not at 0000:00:02.0.
    pciAddress = lib.mkOption {
      type = lib.types.str;
      default = "0000:00:02.0";
      description = "PCI address of the iGPU used for SR-IOV configuration.";
    };

    # Number of Virtual Functions (VFs) to create (typically up to 7 for Intel UHD Graphics).
    numVFs = lib.mkOption {
      type = lib.types.int;
      default = 7;
      description = "Number of Virtual Functions (VFs) to create.";
    };
  };

  config = lib.mkIf config.hardware.graphics.i915-sriov-dkms.enable {
    boot.initrd.kernelModules = ["i915-sriov-dkms"];

    boot.kernelParams = [
      "intel_iommu=on"
      "i915.enable_guc=3"
      "i915.max_vfs=${toString config.hardware.graphics.i915-sriov-dkms.numVFs}"
      "module_blacklist=xe"
    ];

  
    systemd.services.i915SriovVFSetup = {
      description = "Configure i915 SR-IOV Virtual Functions";
      after = [ "systemd-modules-load.service" "local-fs.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.coreutils}/bin/echo ${toString config.hardware.graphics.i915-sriov-dkms.numVFs} > /sys/devices/pci0000:00/0000:00:02.0/sriov_numvfs";
      };
    };

  };
}
