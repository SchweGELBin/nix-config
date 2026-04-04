{ config, lib, ... }:
let
  nginx = config.sys.nginx;
  cfg = nginx.immich;
in
{
  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      immich = {
        enable = true;
        port = cfg.port;
        settings.server.externalDomain = "https://${cfg.fqdn}";
      };
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
    };
  };

  options = {
    sys.nginx.immich = {
      enable = lib.mkEnableOption "Enable Immich";
      fqdn = lib.mkOption {
        default = "immich.${nginx.domain}";
        description = "Immich Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 2283;
        description = "Immich Port";
        type = lib.types.port;
      };
    };
  };
}
