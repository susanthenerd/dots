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
        "usbhid"
        "sd_mod"
      ];

      kernelModules = [
        "dm-snapshot"
      ];
    };

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
    ];

    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };

  services = {
    udev.packages = [ pkgs.ddcutil ];
    hardware.bolt.enable = true;
  };

  hardware = {
    kvmfr = {
      enable = true;
      staticSizeMB = 128;
      user = "susan";
      group = "kvm";
    };

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
      ];
      sriov.enable = true;
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

    i2c.enable = true;
  };
}
