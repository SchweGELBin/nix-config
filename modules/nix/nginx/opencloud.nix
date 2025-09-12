{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.opencloud.enable;
in
{
  config = lib.mkIf enable {
    services = {
      nginx.virtualHosts.${cfg.opencloud.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.opencloud.port}";
      };
      opencloud = {
        enable = true;
        port = cfg.opencloud.port;
        url = cfg.opencloud.url;
      };
    };
  };
}
