{
  config,
  lib,
  pkgs,
  ...
}:
{
  time.timeZone = "Europe/Bucharest";
  security.polkit.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.recursive-mono
    fira
    recursive
  ];

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.fish;
    users.susan = {
      isNormalUser = true;
      extraGroups = [
        "docker"
        "wheel"
        "video"
        "networkmanager"
        "libvirtd"
      ];
      hashedPassword = "$6$vru/Kz/2RFnBeCXQ$FPDE/DET/P2pNfE2bpVsEdDCeMegmeMApE4l3m/2YR9t6qCSrdiTzqUr8aN1gnOTAcYXBQ30NUf3UtqxINmDL.";
    };
  };

  programs = {
    dconf.enable = true;
    fish.enable = true;
    neovim.enable = true;
    git.enable = true;
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-since 10d";
      };
      flake = "/home/susan/dots";
    };
  };

  environment.systemPackages = with pkgs; [
    nixd
    nixfmt-rfc-style
    sbctl
    pciutils
    killall

  ];

  system = {
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "25.05"; # Did you read the comment?
    rebuild.enableNg = true;
  };

  documentation.nixos.enable = false;
}
