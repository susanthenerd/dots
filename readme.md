# Susan's Nixos config

This is my personal nixos config with all other things. Note it's quite a mess so don't take inspiration from it.

## How to install

### Set the password

```sh
echo -n "Password" > /tmp/password.key
```

### Do the install

```sh
sudo nix --experimental-features 'nix-command flakes' run 'github:nix-community/disko/latest#disko-install' -- --write-efi-boot-entries --flake 'github:susanthenerd/dots#xps' --disk nvme /dev/nvme0
```
