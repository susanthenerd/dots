{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking = {
    hostName = "framework";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall.trustedInterfaces = [
      "wlp166s0"
      "virbr0"
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "xe"
        "usbhid"
        "sd_mod"
      ];

      kernelModules = [
        "dm-snapshot"
        "xe"
      ];
    };

    blacklistedKernelModules = [ "i915" ];

    kernelModules = [
      "kvm-intel"
    ];

    extraModulePackages = [ ];

    loader = {
      systemd-boot = {
        enable = lib.mkForce true;
      };
      efi.canTouchEfiVariables = true;
    };

    plymouth.enable = true;
    lanzaboote = {
      enable = false;
      pkiBundle = "/etc/secureboot";
    };

    kernelParams = [
      "iommu=pt"
      "intel_iommu=on"
      "i915.force_probe=!46a6"
      "xe.force_probe=46a6"
      "xe.max_vfs=7"
    ];

    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };

  services = {
    udev = {
      packages = [ pkgs.ddcutil ];
      extraRules = ''
        ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:00:02.0",ATTR{sriov_numvfs}="7"
      '';
    };
    hardware.bolt.enable = true;
  };

  hardware = {
    kvmfr.enable = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
      ];
    };

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };

    cpu = {
      intel.updateMicrocode = true;
      x86.msr.enable = true;
    };

    enableRedistributableFirmware = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    gpgSmartcards.enable = true;
    i2c.enable = true;
  };
}
