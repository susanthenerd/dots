{ stdenv, lib, fetchFromGitHub, kernel, kmod }:
{
  stdenv.mkDerivation (finalAttrs: {
    pname = "i915-sriov-dkms-${pkgs.linuxHeaders.version}";
    version = "v2025.01.22";

    src = pkgs.fetchFromGitHub {
      owner = "strongtz";
      repo = "i915-sriov-dkms";
      rev = version;
      sha256 = "sha256-183y9jzc5fc70fc4f93b8aq8rdd87askqvp5ayx62vx0anbm3g34";
    };


    hardeningDisable = [ "pic" "format" ];
    nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

    makeFlags = [
      "KERNELRELEASE=${kernel.modDirVersion}"
      "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "INSTALL_MOD_PATH=$(out)"
    ];

    meta = {
      description = "DKMS module for Linux i915 driver with SR-IOV support (kernel ${pkgs.linuxHeaders.version})";
      homepage = "https://github.com/strongtz/i915-sriov-dkms";
      license = lib.licenses.mit;
      longDescription = ''
        Experimental DKMS module enabling SR-IOV support in the Linux i915 driver.
        Tested on kernel versions 6.8–6.13. Use with caution!
      '';
      maintainers = with lib.maintainers; [ "susanthenerd" ];
      platforms = lib.platforms.linux;
    };
  });
}