{ ... }:
{
  flake.homeModules.tablet =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        xournalpp
        rnote
      ];

      wayland.windowManager.sway.config = {
        # keep pen and touch on the built-in panel so they follow its rotation
        input = {
          "type:touch".map_to_output = "eDP-1";
          "type:tablet_tool".map_to_output = "eDP-1";
        };

        startup = [
          { command = "${pkgs.rot8}/bin/rot8 --display eDP-1"; }
        ];
      };
    };
}
