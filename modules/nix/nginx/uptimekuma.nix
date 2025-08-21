{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.uptimekuma.enable;
in
{
  config = lib.mkIf enable {
    services = {
      nginx.virtualHosts.${cfg.uptimekuma.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.uptimekuma.port}";
      };
      uptime-kuma = {
        enable = true;
        appriseSupport = true;
        settings.PORT = toString cfg.uptimekuma.port;
      };
    };
  };
}
