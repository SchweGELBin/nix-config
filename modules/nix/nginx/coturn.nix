{
  config,
  inputs,
  lib,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.coturn;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf (nginx.enable && cfg.enable) {
    networking.firewall = {
      allowedTCPPorts = [
        cfg.port
        cfg.port-alt
      ];
      allowedUDPPortRanges = [
        {
          from = cfg.relay-min;
          to = cfg.relay-max;
        }
      ];
    };
    security.acme.certs.${cfg.fqdn} = {
      group = "turnserver";
      postRun = "systemctl reload nginx.service; systemctl restart coturn.service";
    };
    services = {
      coturn = {
        enable = true;
        alt-tls-listening-port = cfg.port-alt;
        cert = "/var/lib/acme/${cfg.fqdn}/cert.pem";
        pkey = "/var/lib/acme/${cfg.fqdn}/key.pem";
        max-port = cfg.relay-max;
        min-port = cfg.relay-min;
        no-tcp-relay = true;
        realm = cfg.fqdn;
        secure-stun = true;
        static-auth-secret-file = secrets.path;
        tls-listening-port = cfg.port;
        use-auth-secret = true;
      };
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
      };
    };
    sops.secrets.coturn.owner = "turnserver";
    users.users.nginx.extraGroups = [ "turnserver" ];
  };

  options = {
    sys.nginx.coturn = {
      enable = lib.mkEnableOption "Enable Turn";
      fqdn = lib.mkOption {
        default = "turn.${nginx.domain}";
        description = "Turn Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 5349;
        description = "Turn Port";
        type = lib.types.port;
      };
      port-alt = lib.mkOption {
        default = 5350;
        description = "Turn Alternative Port";
        type = lib.types.port;
      };
      relay-max = lib.mkOption {
        default = 50000;
        description = "Turn Relay Range Max";
        type = lib.types.port;
      };
      relay-min = lib.mkOption {
        default = 49500;
        description = "Turn Relay Range Min";
        type = lib.types.port;
      };
    };
  };
}
