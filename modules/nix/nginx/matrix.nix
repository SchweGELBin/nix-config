{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.matrix.enable;
in
{
  config = lib.mkIf enable {
    services = {
      matrix-conduit = {
        enable = true;
        settings.global = {
          allow_registration = true;
          database_backend = "rocksdb";
          enable_lightning_bolt = false;
          port = cfg.matrix.port;
          server_name = cfg.domain;
          turn_secret = "CCtSExOF9jBoi6Aj5y6boZZCImyFLQxE";
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
      mautrix-discord = {
        enable = cfg.matrix.discord.enable;
        package = (pkgs.mautrix-discord.override { withGoolm = true; });
        settings = {
          appservice.port = cfg.matrix.discord.port;
          bridge = {
            encryption = {
              allow = true;
              default = true;
              require = true;
            };
            permissions.${cfg.domain} = "user";
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
        settings = {
          appservice.port = cfg.matrix.whatsapp.port;
          bridge = {
            encryption = {
              allow = true;
              default = true;
              require = true;
            };
            permissions.${cfg.domain} = "user";
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
  };
}
