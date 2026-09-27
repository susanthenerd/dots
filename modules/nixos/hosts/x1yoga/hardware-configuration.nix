{ ... }:
{
  flake.nixosModules.x1YogaHardware =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    let
      ddcciDriver = config.boot.kernelPackages.ddcci-driver.overrideAttrs (old: {
        # Linux 7.2 removed strncpy from the in-kernel API.
        # https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux/-/merge_requests/20
        postPatch = (old.postPatch or "") + ''
          substituteInPlace ddcci/ddcci.c \
            --replace-warn 'strncpy(' 'strscpy('
        '';
      });
    in
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      networking = {
        hostName = "x1yoga";
        networkmanager = {
          enable = true;
          wifi.backend = "iwd";
          plugins = [ pkgs.networkmanager-openvpn ];
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
          # TODO: confirm with `ip link` after install (AX201 CNVi is usually wlp0s20f3)
          "wlp0s20f3"
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
            "i915"
          ];
        };

        blacklistedKernelModules = [ ];

        extraModulePackages = [
          ddcciDriver
        ];

        kernelModules = [
          "kvm-intel"
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
          "i915.enable_guc=3"
        ];

        kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
      };

      programs.solaar.enable = true;

      services = {
        udev = {
          packages = [ pkgs.ddcutil ];
        };
        hardware.bolt.enable = true;
        thermald.enable = true;
        fstrim.enable = true;
        power-profiles-daemon.enable = true;
      };

      hardware = {
        graphics = {
          enable = true;
          extraPackages = with pkgs; [
            intel-media-driver
            intel-compute-runtime
            vpl-gpu-rt
          ];
          extraPackages32 = with pkgs.driversi686Linux; [
            intel-media-driver
          ];
        };

        trackpoint = {
          enable = true;
          emulateWheel = true;
        };

        # automatic screen orientation
        sensor.iio.enable = true;

        logitech.wireless.enable = true;

        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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
