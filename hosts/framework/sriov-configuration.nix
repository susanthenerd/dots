{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Use linux_latest as requested
  baseKernelPkg = pkgs.linuxPackages_latest.kernel;

  # Define the custom kernel with necessary options for SR-IOV
  customKernel = baseKernelPkg.override {
    structuredExtraConfig = with lib.kernel; {
      DRM_I915_PXP = yes;
      INTEL_MEI_PXP = module;
    };
  };

  # Kernel packages for the custom kernel
  customKernelPackages = pkgs.linuxPackagesFor customKernel;

  # Define the i915 SR-IOV module derivation using the custom kernel packages
  i915SRIOVModule = customKernelPackages.callPackage (
    {
      stdenv,
      lib,
      fetchFromGitHub,
      kernel,
      xz,
      ...
    }:
    stdenv.mkDerivation rec {
      pname = "i915-sriov-dkms";
      version = "2025.03.27";

      src = fetchFromGitHub {
        owner = "strongtz";
        repo = "i915-sriov-dkms";
        rev = "${version}";
        sha256 = "sha256-KDEFKa7bgDsm/GCvYDFObNDoZn2c71oaQlgYMAN2B0I=";
      };

      nativeBuildInputs = kernel.moduleBuildDependencies ++ [ xz ];

      makeFlags = [
        "KERNELRELEASE=${kernel.modDirVersion}"
        "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      ];

      buildPhase = ''
        make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
          M=$(pwd) \
          KERNELRELEASE=${kernel.modDirVersion}
      '';

      installPhase = ''
        mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra
        ${xz}/bin/xz -z -f i915.ko
        cp i915.ko.xz $out/lib/modules/${kernel.modDirVersion}/extra/i915-sriov.ko.xz
      '';

      meta = {
        description = "Custom module for i915 SRIOV support";
        homepage = "https://github.com/strongtz/i915-sriov-dkms";
        license = lib.licenses.gpl2Only;
        platforms = lib.platforms.linux;
      };
    }
  ) { };
in
{
  options.hardware.sriov.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Intel i915 SR-IOV support (uses custom kernel and module).";
  };

  # Apply SR-IOV configurations only if the option is enabled
  config = lib.mkIf config.hardware.sriov.enable {
    boot = {
      kernelPackages = customKernelPackages;

      initrd.kernelModules = [ "i915-sriov" ];

      kernelModules = [ "i915-sriov" ];

      extraModulePackages = [ i915SRIOVModule ];

      blacklistedKernelModules = [
        "i915"
        "xe"
      ];

      extraModprobeConfig = ''
        options i915-sriov enable_guc=3
        options i915-sriov max_vfs=7
      '';

      postBootCommands = ''
        ${pkgs.kmod}/bin/depmod -a ${customKernel.modDirVersion}
      '';
    };

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:00:02.0",ATTR{sriov_numvfs}="7"
    '';

  };
}
