{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.llama-server;
  presetsFile = pkgs.writeText "llama-presets.ini" (lib.generators.toINI { } cfg.settings);
in
{
  options.services.llama-server = {
    enable = lib.mkEnableOption "llama-server in router mode";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.llama-cpp;
      description = "llama-server package to use.";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
    };

    modelsDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
    };

    modelsMax = lib.mkOption {
      type = lib.types.int;
      default = 4;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Presets INI config as Nix attrset.";
    };

    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.llama-server = {
      description = "llama-server (router mode)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = lib.escapeShellArgs (
          [ "${cfg.package}/bin/llama-server" ]
          ++ [
            "--host"
            cfg.host
          ]
          ++ [
            "--port"
            (builtins.toString cfg.port)
          ]
          ++ lib.optionals (cfg.modelsDir != null) [
            "--models-dir"
            cfg.modelsDir
          ]
          ++ [
            "--models-max"
            (builtins.toString cfg.modelsMax)
          ]
          ++ lib.optionals (cfg.settings != { }) [
            "--models-preset"
            presetsFile
          ]
          ++ cfg.extraFlags
        );
        Restart = "on-failure";
        RestartSec = 10;
        DynamicUser = true;
        CacheDirectory = "llama-server";
        PrivateDevices = false;
        Environment = [
          "LD_LIBRARY_PATH=/run/opengl-driver/lib"
          "HOME=/var/cache/llama-server"
          "ROCBLAS_USE_HIPBLASLT=1"
        ];
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
