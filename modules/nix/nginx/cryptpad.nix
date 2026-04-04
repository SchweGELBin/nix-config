{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.cryptpad.enable;
in
{
  config = lib.mkIf enable {
    services = {
      cryptpad = {
        enable = true;
        settings = {
          httpPort = cfg.cryptpad.port;
          httpSafeOrigin = "https://" + cfg.cryptpad.fqdn-safe;
          httpSafePort = cfg.cryptpad.port-safe;
          httpUnsafeOrigin = "https://" + cfg.cryptpad.fqdn;
          webSocketPort = cfg.cryptpad.port-sock;
        };
      };
      nginx.virtualHosts.${cfg.cryptpad.fqdn} = {
        serverAliases = [ cfg.cryptpad.fqdn-safe ];
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.cryptpad.port}";
        locations."/cryptpad_websocket" = {
          proxyPass = "http://localhost:${toString cfg.cryptpad.port-sock}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
