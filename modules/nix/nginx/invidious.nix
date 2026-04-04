{ config, lib, ... }:
let
  nginx = config.sys.nginx;
  cfg = nginx.invidious;
in
{
  config = lib.mkIf (nginx.enable && cfg.enable) {
    services.invidious = {
      enable = true;
      domain = cfg.fqdn;
      nginx.enable = true;
      port = cfg.port;
    };
  };

  options = {
    sys.nginx.invidious = {
      enable = lib.mkEnableOption "Enable Invidious";
      fqdn = lib.mkOption {
        default = "iv.${nginx.domain}";
        description = "Invidious Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 3500;
        description = "Invidious Port";
        type = lib.types.port;
      };
    };
  };
}
