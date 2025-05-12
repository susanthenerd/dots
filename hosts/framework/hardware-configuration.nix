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
    ./sriov-configuration.nix
  ];

  networking = {
    hostName = "framework";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
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
        "kvmfr"
      ];
    };

    kernelModules = [
      "kvm-intel"
      "kvmfr"
    ];

    extraModulePackages = [
      config.boot.kernelPackages.kvmfr
    ];

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

    extraModprobeConfig = ''
      options kvmfr static_size_mb=128
    '';
  };

  services.udev = {
    extraRules = ''
      SUBSYSTEM=="kvmfr", OWNER="susan", GROUP="kvm", MODE="0660"
    '';
  };

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
      ];
    };

    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
