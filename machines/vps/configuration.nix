{
  modulesPath,
  lib,
  pkgs,
  ...
}@args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../modules/nixos/headscale.nix
    ../../modules/nixos/tailscale.nix
    ../../modules/nixos/caddy.nix
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  system.stateVersion = "25.05";

  networking = {
    hostName = "vps";
    firewall.trustedInterfaces = [
      "tailscale0"
    ];

    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINcre3PZxAV2Zt46k5NTegD4NgyzDnwrxFOr9g5vsUYr"
  ];
}
