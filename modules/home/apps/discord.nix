{ ... }:
{
  flake.homeModules.discord =
    { pkgs, ... }:
    {
      programs.discord = {
        enable = true;
        package = (
          pkgs.discord.override {
            withVencord = true;
          }
        );
      };
    };
}
