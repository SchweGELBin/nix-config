{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.matrix;
  secrets = config.sops.secrets;
  localaddress = "http://localhost:${toString cfg.matrix.port}";
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      matrix-conduit = {
        enable = true;
        secretFile = secrets.matrix_env.path;
        settings.global = {
          allow_registration = true;
          database_backend = "rocksdb";
          enable_lightning_bolt = false;
          port = cfg.port;
          server_name = nginx.domain;
          turn_uris = [
            "turn:${nginx.coturn.fqdn}:${toString nginx.coturn.port}?transport=tcp"
            "turn:${nginx.coturn.fqdn}:${toString nginx.coturn.port}?transport=udp"
            "turn:${nginx.coturn.fqdn}:${toString nginx.coturn.port-alt}?transport=tcp"
            "turn:${nginx.coturn.fqdn}:${toString nginx.coturn.port-alt}?transport=udp"
          ];
          well_known_client = "https://${cfg.fqdn}";
          well_known_server = cfg.fqdn;
        };
      };
      mautrix-signal = {
        enable = cfg.signal.enable;
        environmentFile = secrets.mautrix-signal_env.path;
        settings = {
          appservice.port = cfg.signal.port;
          bridge.permissions.${nginx.domain} = "user";
          encryption = {
            allow = true;
            default = true;
            pickle_key = "$MAUTRIX_SIGNAL_ENCRYPTION_PICKLE_KEY";
            require = true;
          };
          homeserver = {
            address = localaddress;
            domain = nginx.domain;
          };
        };
      };
      mautrix-whatsapp = {
        enable = cfg.whatsapp.enable;
        environmentFile = secrets.mautrix-whatsapp_env.path;
        settings = {
          appservice.port = cfg.whatsapp.port;
          bridge.permissions.${nginx.domain} = "user";
          encryption = {
            allow = true;
            default = true;
            pickle_key = "$MAUTRIX_WHATSAPP_ENCRYPTION_PICKLE_KEY";
            require = true;
          };
          homeserver = {
            address = localaddress;
            domain = nginx.domain;
          };
        };
      };
      nginx.virtualHosts = {
        ${nginx.domain}.locations = {
          "/.well-known/".proxyPass = localaddress;
          "/_matrix/".proxyPass = localaddress;
        };
        ${cfg.fqdn} = {
          enableACME = true;
          forceSSL = true;
          locations."/".proxyPass = localaddress;
        };
      };
    };
    sops.secrets = {
      matrix_env.owner = "root";
      mautrix-signal_env.owner = lib.mkIf cfg.matrix.signal.enable "mautrix-signal";
      mautrix-whatsapp_env.owner = lib.mkIf cfg.matrix.whatsapp.enable "mautrix-whatsapp";
    };
  };

  options = {
    sys.nginx.matrix = {
      enable = lib.mkEnableOption "Enable Matrix";
      fqdn = lib.mkOption {
        default = "matrix.${nginx.domain}";
        description = "Matrix Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 6167;
        description = "Matrix Port";
        type = lib.types.port;
      };
      signal = {
        enable = lib.mkEnableOption "Enable Signal Bridge" // {
          default = true;
        };
        port = lib.mkOption {
          default = 29328;
          description = "Signal Bridge Port";
          type = lib.types.port;
        };
      };
      whatsapp = {
        enable = lib.mkEnableOption "Enable WhatsApp Bridge" // {
          default = true;
        };
        port = lib.mkOption {
          default = 29318;
          description = "WhatsApp Bridge Port";
          type = lib.types.port;
        };
      };
    };
  };
}
