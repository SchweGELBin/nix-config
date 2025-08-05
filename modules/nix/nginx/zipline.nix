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
        environmentFiles = [ secrets.zipline_env.path ];
        settings = {
          CORE_DEFAULT_DOMAIN = cfg.zipline.fqdn;
          CORE_PORT = cfg.zipline.port;
          CORE_RETURN_HTTPS_URLS = lib.boolToString true;
        };
      };
      nginx.virtualHosts.${cfg.zipline.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.zipline.port}";
      };
    };
    sops.secrets.zipline_env.owner = "root";
  };
}
