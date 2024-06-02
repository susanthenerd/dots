{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  networking = {
    hostName = "framework";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/ee2b1f06-a609-46b5-9473-91ac6d0af432";
      fsType = "btrfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/F82A-A86B";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/15b75aa0-73db-48e0-87b2-d5e83ed7a680"; }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices."luks" = {
        device = "/dev/disk/by-uuid/f1d7c1dd-3b82-4603-bcd8-b8ac2652e036";
        preLVM = true;
      };
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };


  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
      ];
    };

    pulseaudio.enable = false;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
