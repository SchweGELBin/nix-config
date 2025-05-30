{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.turn.enable;
in
{
  config = lib.mkIf enable {
    networking.firewall = {
      allowedTCPPorts = [
        cfg.turn.port
        cfg.turn.port-alt
      ];
      allowedUDPPortRanges = [
        {
          from = cfg.turn.relay-min;
          to = cfg.turn.relay-max;
        }
      ];
    };
    security.acme.certs.${cfg.turn.fqdn} = {
      group = "turnserver";
      postRun = "systemctl reload nginx.service; systemctl restart coturn.service";
    };
    services = {
      coturn = {
        enable = true;
        alt-tls-listening-port = cfg.turn.port-alt;
        cert = "/var/lib/acme/${cfg.turn.fqdn}/cert.pem";
        pkey = "/var/lib/acme/${cfg.turn.fqdn}/key.pem";
        max-port = cfg.turn.relay-max;
        min-port = cfg.turn.relay-min;
        no-tcp-relay = true;
        realm = cfg.turn.fqdn;
        secure-stun = true;
        static-auth-secret = "CCtSExOF9jBoi6Aj5y6boZZCImyFLQxE";
        tls-listening-port = cfg.turn.port;
        use-auth-secret = true;
      };
      nginx.virtualHosts.${cfg.turn.fqdn} = {
        enableACME = true;
        forceSSL = true;
      };
    };
    users.users.nginx.extraGroups = [ "turnserver" ];
  };
}
