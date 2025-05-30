{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.immich.enable;
in
{
  config = lib.mkIf enable {
    services = {
      immich = {
        enable = true;
        port = cfg.immich.port;
        settings.server.externalDomain = "https://${cfg.immich.fqdn}";
      };
      nginx.virtualHosts.${cfg.immich.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.immich.port}";
      };
    };
  };
}
