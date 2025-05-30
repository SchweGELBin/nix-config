{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.jellyfin.enable;
in
{
  config = lib.mkIf enable {
    services = {
      jellyfin.enable = true;
      nginx.virtualHosts.${cfg.jellyfin.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.jellyfin.port}";
      };
    };
  };
}
