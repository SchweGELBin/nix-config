{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.collabora.enable;
in
{
  config = lib.mkIf enable {
    services = {
      collabora-online = {
        enable = true;
        port = cfg.collabora.port;
        settings = {
          server_name = cfg.collabora.fqdn;
          ssl.enable = false;
        };
      };
      nginx.virtualHosts.${cfg.collabora.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.collabora.port}";
      };
    };
  };
}
