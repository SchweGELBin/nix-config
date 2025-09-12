{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.filebrowser.enable;
in
{
  config = lib.mkIf enable {
    services = {
      nginx.virtualHosts.${cfg.filebrowser.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.filebrowser.port}";
      };
      filebrowser = {
        enable = true;
        settings.port = cfg.opencloud.port;
      };
    };
  };
}
