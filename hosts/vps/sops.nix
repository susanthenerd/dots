{
  config,
  lib,
  pkgs,
  ...
}:
{
  sops.defaultSopsFile = ./secrets/vps.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
}
