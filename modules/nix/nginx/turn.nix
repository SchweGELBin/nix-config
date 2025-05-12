{
  config,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.turn.enable;
  vars = import ../vars.nix;
in
{
  config = lib.mkIf enable {
    security.acme.certs."turn.${vars.my.domain}" = {
      group = "turnserver";
      postRun = "systemctl reload nginx.service; systemctl restart coturn.service";
    };
    services = {
      coturn = {
        enable = true;
        alt-listening-port = null;
        alt-tls-listening-port = cfg.turn.port-alt;
        cert = "/var/lib/acme/turn.${vars.my.domain}/fullchain.pem";
        pkey = "/var/lib/acme/turn.${vars.my.domain}/key.pem";
        listening-port = null;
        max-port = cfg.turn.relay-max;
        min-port = cfg.turn.relay-min;
        no-tcp-relay = true;
        realm = "turn.${vars.my.domain}";
        secure-stun = true;
        static-auth-secret = "CCtSExOF9jBoi6Aj5y6boZZCImyFLQxE";
        tls-listening-port = cfg.turn.port;
        use-auth-secret = true;
      };
      nginx.virtualHosts."turn.${vars.my.domain}" = {
        enableACME = true;
        forceSSL = true;
      };
    };

    users.users.nginx.extraGroups = [ "turnserver" ];
  };
}
