{config, lib, pkgs, ... } : {
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "transfeminine";
      mode = "rgb";
      light_dark = "dark";
      lightness = 0.65;
      color_align =  {
        mode = "custom";
        custom_colors = {
          "1" = 3;
          "2" = 0;
        };
        fore_back = [];
      };
      backend = "fastfetch";
      args = null;
      distro = null;
      pride_mont_show = [];
      pride_month_disable = false;
    };
  };
}
