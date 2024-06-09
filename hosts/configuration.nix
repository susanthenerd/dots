{ config, lib, pkgs, ... }:
{
  time.timeZone = "Europe/Bucharest";
  security.polkit.enable = true;

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "Recursive" ]; })
    fira
  ];


  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.fish;
    users.susan = {
      isNormalUser = true;
      extraGroups = [ "wheel" "video" "networkmanager" ];
      hashedPassword = "$6$vru/Kz/2RFnBeCXQ$FPDE/DET/P2pNfE2bpVsEdDCeMegmeMApE4l3m/2YR9t6qCSrdiTzqUr8aN1gnOTAcYXBQ30NUf3UtqxINmDL.";
    };
  };

  programs = {
    dconf.enable = true;
    fish.enable = true;
    neovim.enable = true;
    git.enable = true;
    firefox.enable = true;
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };
  };

  environment.systemPackages = with pkgs; [
    ddcutil
    nixd
    nixpkgs-fmt
    qbittorrent
    
  ];



  system = {
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "24.05"; # Did you read the comment?
  };
}
