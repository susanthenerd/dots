{...}: {
  flake.homeModules.swayEasyfocus = {
    programs.sway-easyfocus = {
      enable = true;
      settings = {
        chars= "fjghdkslaemuvitywoqpcbnxz";
      };
    };
  };
}
