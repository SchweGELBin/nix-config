{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.zipline.enable;
  secrets = config.sops.secrets;
in
{
  config = lib.mkIf enable {
    services = {
      zipline = {
        enable = true;
        environmentFiles = [ secrets.zipline.path ];
        settings.CORE_PORT = cfg.zipline.port;
      };
      nginx.virtualHosts.${cfg.zipline.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.zipline.port}";
      };
    };
    sops.secrets.zipline.owner = "zipline";
  };
}
