{ config, lib, ... }:
let
  nginx = config.sys.nginx;
  cfg = nginx.zipline;
  secrets = config.sops.secrets;
in
{
  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      zipline = {
        enable = true;
        environmentFiles = [ secrets.zipline_env.path ];
        settings = {
          CORE_DEFAULT_DOMAIN = cfg.fqdn;
          CORE_PORT = cfg.port;
          CORE_RETURN_HTTPS_URLS = lib.boolToString true;
        };
      };
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
    };
    sops.secrets.zipline_env.owner = "root";
  };

  options = {
    sys.nginx.zipline = {
      enable = lib.mkEnableOption "Enable Zipline";
      fqdn = lib.mkOption {
        default = "zip.${nginx.domain}";
        description = "Zipline Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 3002;
        description = "Zipline Port";
        type = lib.types.port;
      };
    };
  };
}
