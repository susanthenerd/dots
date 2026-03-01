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
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    wireless.iwd = {
      enable = true;
      settings = {
        Network = {
          EnableIPv6 = true;
        };
        Settings = {
          AutoConnect = true;
        };
      };
    };
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
        "amdgpu"
        "sd_mod"
      ];

      kernelModules = [
        "dm-snapshot"
      ];
    };

    blacklistedKernelModules = [ ];

    extraModulePackages = [
      config.boot.kernelPackages.ddcci-driver
    ];

    kernelModules = [
      "i2c-dev"
      "ddcci_backlight"
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
      "amd_iommu=on"
      "amd_pstate=active"
      "ttm.pages_limit=30720000"
      "ttm.page_pool_size=30720000"
    ];

    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };

  services = {
    udev = {
      packages = [ pkgs.ddcutil ];
    };
    hardware.bolt.enable = true;
  };

  hardware = {
    kvmfr.enable = true;
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };

    opengl.extraPackages = [
      pkgs.rocmPackages.clr.icd
    ];

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
      ];
    };

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };

    cpu = {
      amd = {
        updateMicrocode = true;
        ryzen-smu.enable = true;
      };
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
