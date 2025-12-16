{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.whoogle.enable;
in
{
  config = lib.mkIf enable {
    services = {
      nginx.virtualHosts.${cfg.whoogle.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.whoogle.port}";
      };
      whoogle-search = {
        enable = true;
        port = cfg.whoogle.port;
      };
    };
  };
}
