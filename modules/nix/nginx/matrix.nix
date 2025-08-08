{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.matrix.enable;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services = {
      matrix-conduit = {
        enable = true;
        secretFile = secrets.matrix_env.path;
        settings.global = {
          allow_registration = true;
          database_backend = "rocksdb";
          enable_lightning_bolt = false;
          port = cfg.matrix.port;
          server_name = cfg.domain;
          turn_uris = [
            "turn:${cfg.turn.fqdn}:${toString cfg.turn.port}?transport=tcp"
            "turn:${cfg.turn.fqdn}:${toString cfg.turn.port}?transport=udp"
            "turn:${cfg.turn.fqdn}:${toString cfg.turn.port-alt}?transport=tcp"
            "turn:${cfg.turn.fqdn}:${toString cfg.turn.port-alt}?transport=udp"
          ];
          trusted_servers = [
            "matrix.org"
            "mau.chat"
          ];
          well_known_client = "https://${cfg.matrix.fqdn}";
          well_known_server = cfg.matrix.fqdn;
        };
      };
      mautrix-signal = {
        enable = cfg.matrix.signal.enable;
        package = (pkgs.mautrix-signal.override { withGoolm = true; });
        environmentFile = secrets.mautrix-signal_env.path;
        settings = {
          appservice.port = cfg.matrix.signal.port;
          bridge.permissions.${cfg.domain} = "user";
          encryption = {
            allow = true;
            default = true;
            pickle_key = "$MAUTRIX_SIGNAL_ENCRYPTION_PICKLE_KEY";
            require = true;
          };
          homeserver = {
            address = "http://localhost:${toString cfg.matrix.port}";
            domain = cfg.domain;
          };
        };
      };
      mautrix-whatsapp = {
        enable = cfg.matrix.whatsapp.enable;
        package = (pkgs.mautrix-whatsapp.override { withGoolm = true; });
        environmentFile = secrets.mautrix-whatsapp_env.path;
        settings = {
          appservice.port = cfg.matrix.whatsapp.port;
          bridge.permissions.${cfg.domain} = "user";
          encryption = {
            allow = true;
            default = true;
            pickle_key = "$MAUTRIX_WHATSAPP_ENCRYPTION_PICKLE_KEY";
            require = true;
          };
          homeserver = {
            address = "http://localhost:${toString cfg.matrix.port}";
            domain = cfg.domain;
          };
        };
      };
      nginx.virtualHosts.${cfg.matrix.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.matrix.port}";
      };
    };
    sops.secrets = {
      matrix_env.owner = "root";
      mautrix-signal_env = "mautrix-signal";
      mautrix-whatsapp_env = "mautrix-whatsapp";
    };
  };
}
