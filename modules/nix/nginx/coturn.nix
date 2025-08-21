{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.coturn.enable;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    networking.firewall = {
      allowedTCPPorts = [
        cfg.coturn.port
        cfg.coturn.port-alt
      ];
      allowedUDPPortRanges = [
        {
          from = cfg.coturn.relay-min;
          to = cfg.coturn.relay-max;
        }
      ];
    };
    security.acme.certs.${cfg.coturn.fqdn} = {
      group = "turnserver";
      postRun = "systemctl reload nginx.service; systemctl restart coturn.service";
    };
    services = {
      coturn = {
        enable = true;
        alt-tls-listening-port = cfg.coturn.port-alt;
        cert = "/var/lib/acme/${cfg.coturn.fqdn}/cert.pem";
        pkey = "/var/lib/acme/${cfg.coturn.fqdn}/key.pem";
        max-port = cfg.coturn.relay-max;
        min-port = cfg.coturn.relay-min;
        no-tcp-relay = true;
        realm = cfg.coturn.fqdn;
        secure-stun = true;
        static-auth-secret-file = secrets.coturn.path;
        tls-listening-port = cfg.coturn.port;
        use-auth-secret = true;
      };
      nginx.virtualHosts.${cfg.coturn.fqdn} = {
        enableACME = true;
        forceSSL = true;
      };
    };
    sops.secrets.coturn.owner = "turnserver";
    users.users.nginx.extraGroups = [ "turnserver" ];
  };
}
