{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.peertube.enable;
in
{
  config = lib.mkIf enable {
    services = {
      uptime-kuma = {
        enable = true;
        appriseSupport = true;
        settings.PORT = toString cfg.uptime.port;
      };
      nginx.virtualHosts.${cfg.uptime.fqdn} = {
        enableACME = true;
        forceSSL = true;
      };
    };
  };
}
