{ config, lib, ... }:
let
  nginx = config.sys.nginx;
  cfg = nginx.prosody;
in
{
  config = lib.mkIf (nginx.enable && cfg.enable) {
    networking.firewall.allowedTCPPorts = [
      5000 # File Transfer Proxy
      5222 # Client Connections
      5223 # Client Direct TLS
      5269 # Server-To-Server Connections
      5281 # HTTPS
    ];
    security.acme.certs.${nginx.domain}.reloadServices = [ "prosody" ];
    services = {
      movim = {
        enable = cfg.movim.enable;
        domain = cfg.fqdn;
        nginx = {
          enableACME = true;
          forceSSL = true;
        };
        port = cfg.movim.port;
      };
      prosody = {
        enable = true;
        admins = [ "michi@${nginx.domain}" ];
        allowRegistration = true;
        disco_items = [
          {
            description = "HTTP Upload";
            url = config.services.prosody.httpFileShare.domain;
          }
        ];
        extraModules = lib.optional cfg.turn.enable "turn_external";
        httpFileShare = {
          domain = "upload.${cfg.fqdn}";
        };
        httpPorts = [ cfg.port ];
        muc = [
          {
            domain = "room.${cfg.fqdn}";
            name = "MiX Chatrooms";
          }
        ];
        ssl = {
          cert = "/var/lib/acme/${nginx.domain}/cert.pem";
          key = "/var/lib/acme/${nginx.domain}/key.pem";
        };
        virtualHosts.${nginx.domain} = {
          enabled = true;
          domain = nginx.domain;
          extraConfig = lib.optionalString cfg.turn.enable ''
            turn_external_host = "${nginx.coturn.fqdn}";
            turn_external_secret = "V3ry S3cr3t P455w0rt";
          '';
        };
        xmppComplianceSuite = true;
      };
    };
    users.users.prosody.extraGroups = [ "nginx" ];
  };

  options = {
    sys.nginx.prosody = {
      enable = lib.mkEnableOption "Enable Prosody";
      fqdn = lib.mkOption {
        default = "xmpp.${nginx.domain}";
        description = "Prosody Domain";
        type = lib.types.str;
      };
      movim = {
        enable = lib.mkEnableOption "Enable Movim" // {
          default = true;
        };
        port = lib.mkOption {
          default = 5279;
          description = "Movim Port";
          type = lib.types.port;
        };
      };
      port = lib.mkOption {
        default = 5280;
        description = "Prosody Port";
        type = lib.types.port;
      };
      turn.enable = lib.mkEnableOption "Enable Prosody Turn";
    };
  };
}
