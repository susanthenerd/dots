{
  stdenv,
  lib,
  pkgs,
  kernel,
  kmod, ...
}:

stdenv.mkDerivation rec {
  pname = "i915-sriov-dkms";
  version = "2025.02.03";

  src = pkgs.fetchFromGitHub {
    owner = "strongtz";
    repo = "i915-sriov-dkms";
    rev = version;
    sha256 = "sha256-bBcV4Na1VVlw8ftCg6SPG+levrhsxZFJ2BKna5Ar2EQ=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ pkgs.xz ];

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
    ${pkgs.xz}/bin/xz -z -f i915.ko
    cp i915.ko.xz $out/lib/modules/${kernel.modDirVersion}/extra/i915-sriov.ko.xz
  '';

  meta = with lib; {
    description = "DKMS module for Linux i915 driver with SR-IOV support (kernel ${kernel.version})";
    homepage = "https://github.com/strongtz/i915-sriov-dkms";
    license = licenses.gpl2Only;
    longDescription = ''
      Experimental DKMS module enabling SR-IOV support in the Linux i915 driver.
      Tested on kernel versions 6.8–6.13. Use with caution!
    '';
    platforms = platforms.linux;
  };
}
