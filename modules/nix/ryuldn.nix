{ config, lib, ... }:
let
  cfg = config.sys.ryuldn;
in
{
  config = lib.mkIf cfg.enable {
    /*
      https://github.com/NixOS/nixpkgs/pull/458646
      services.ryuldn = {
        enable = true;
        settings.port = cfg.port;
        web = {
          enable = cfg.web.enable;
          settings.port = cfg.web.port;
        };
      };
    */
  };

  options = {
    sys.ryuldn = {
      enable = lib.mkEnableOption "Enable RyuLDN Multiplayer Server";
      port = lib.mkOption {
        description = "RyuLDN port";
        type = lib.types.int;
      };
      web = {
        enable = lib.mkEnableOption "Enable RyuLDN Website";
        port = lib.mkOption {
          description = "RyuLDN Website port";
          type = lib.types.int;
        };
      };
    };
  };
}
