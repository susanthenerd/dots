{config, lib, pkgs, ...} : {
programs.ssh = {
   enable = true;
   extraConfig = ''
    IdentityAgent ~/.1password/agent.sock
   '';
 };
}
