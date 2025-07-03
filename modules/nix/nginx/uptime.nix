{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.uptime.enable;
in
{
  config = lib.mkIf enable {
    services = {
      nginx.virtualHosts.${cfg.uptime.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.uptime.port}";
      };
      uptime-kuma = {
        enable = true;
        appriseSupport = true;
        settings.PORT = toString cfg.uptime.port;
      };
    };
  };
}
