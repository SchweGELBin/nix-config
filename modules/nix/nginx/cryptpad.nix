{ config, lib, ... }:
let
  nginx = config.sys.nginx;
  cfg = nginx.cryptpad;
in
{
  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      cryptpad = {
        enable = true;
        settings = {
          httpPort = cfg.port;
          httpSafeOrigin = "https://" + cfg.safe.fqdn;
          httpSafePort = cfg.safe.port;
          httpUnsafeOrigin = "https://" + cfg.fqdn;
          webSocketPort = cfg.webs.port;
        };
      };
      nginx.virtualHosts.${cfg.fqdn} = {
        serverAliases = [ cfg.safe.fqdn ];
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
        locations."/cryptpad_websocket" = {
          proxyPass = "http://localhost:${toString cfg.webs.port}";
          proxyWebsockets = true;
        };
      };
    };
  };

  options = {
    sys.nginx.cryptpad = {
      enable = lib.mkEnableOption "Enable CryptPad";
      fqdn = lib.mkOption {
        default = "office.${nginx.domain}";
        description = "CryptPad Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 8000;
        description = "CryptPad Port";
        type = lib.types.port;
      };
      safe = {
        fqdn = lib.mkOption {
          default = "office-safe.${nginx.domain}";
          description = "CryptPad Safe Domain";
          type = lib.types.str;
        };
        port = lib.mkOption {
          default = 8001;
          description = "CryptPad Safe Port";
          type = lib.types.port;
        };
      };
      webs.port = lib.mkOption {
        default = 8002;
        description = "CryptPad WebSocket Port";
        type = lib.types.port;
      };
    };
  };
}
