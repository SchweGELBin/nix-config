{ config, lib, ... }:
let
  nginx = config.sys.nginx;
  cfg = nginx.prosody;
in
{
  config = lib.mkIf (nginx.enable && cfg.enable) {
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
            url = "uploads.${cfg.fqdn}";
          }
        ];
        extraModules = lib.optional cfg.turn.enable "turn_external";
        httpFileShare = {
          domain = "uploads.${cfg.fqdn}";
        };
        httpPorts = [ cfg.port ];
        httpsPorts = lib.mkForce [ ];
        muc = [
          {
            domain = "muc.${cfg.fqdn}";
            name = "MiX Chatrooms";
          }
        ];
        virtualHosts.localhost = {
          enabled = true;
          domain = "localhost";
          extraConfig = lib.optionalString cfg.turn.enable ''
            turn_external_host = "${nginx.coturn.fqdn}";
            turn_external_secret = "V3ry S3cr3t P455w0rt";
          '';
        };
        xmppComplianceSuite = true;
      };
    };
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
          default = 5281;
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
