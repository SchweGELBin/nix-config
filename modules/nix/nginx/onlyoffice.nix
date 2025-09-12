{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.onlyoffice.enable;
in
{
  config = lib.mkIf enable {
    services = {
      nginx.virtualHosts.${cfg.onlyoffice.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.onlyoffice.port}";
      };
      onlyoffice = {
        enable = true;
        hostname = cfg.onlyoffice.fqdn;
        port = cfg.onlyoffice.port;
      };
    };
  };
}
