{ config, lib, ... }:
let
  nginx = config.sys.nginx;
  cfg = nginx.uptimekuma;
in
{
  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
      uptime-kuma = {
        enable = true;
        appriseSupport = true;
        settings.PORT = toString cfg.port;
      };
    };
  };

  options = {
    sys.nginx.uptimekuma = {
      enable = lib.mkEnableOption "Enable Uptime Kuma";
      fqdn = lib.mkOption {
        default = "uptime.${nginx.domain}";
        description = "Uptime Kuma Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 3001;
        description = "Uptime Kuma Port";
        type = lib.types.port;
      };
    };
  };
}
