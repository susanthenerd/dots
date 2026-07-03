{ ... }:
{
  flake.nixosModules.xpsHardware =
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
        hostName = "xps";
        networkmanager = {
          enable = true;
          wifi.backend = "iwd";
          plugins = [pkgs.networkmanager-openvpn];
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
            "i915"
            "sd_mod"
          ];

          kernelModules = [
            "dm-snapshot"
            "i915"
          ];
        };

        blacklistedKernelModules = [ ];

        extraModulePackages = [
          config.boot.kernelPackages.ddcci-driver
        ];

        kernelModules = [
          "i2c-dev"
          "ddcci_backlight"
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
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

        nvidia = {
          modesetting.enable = true;

          package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
        };

        graphics = {
          enable = true;

          # TODO: find if any extra is needed
          extraPackages = with pkgs; [

          ];
        };

        logitech.wireless = {
          enable = true;
          enableGraphical = true;
        };

        cpu = {
        };

        enableRedistributableFirmware = true;

        bluetooth = {
          enable = true;
          powerOnBoot = true;
        };

        gpgSmartcards.enable = true;
        i2c.enable = true;
      };
    };
}
