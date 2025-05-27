{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.matrix.enable;

  secrets = config.sops.secrets;
  vars = import ../vars.nix;
in
{
  config = lib.mkIf enable {
    services = {
      matrix-conduit = {
        enable = true;
        extraEnvironment = secrets.conduit_env.path;
        settings.global = {
          allow_registration = true;
          database_backend = "rocksdb";
          enable_lightning_bolt = false;
          port = cfg.matrix.port;
          server_name = vars.my.domain;
          turn_uris = [
            "turn:turn.${vars.my.domain}:${toString cfg.turn.port}?transport=tcp"
            "turn:turn.${vars.my.domain}:${toString cfg.turn.port}?transport=udp"
            "turn:turn.${vars.my.domain}:${toString cfg.turn.port-alt}?transport=tcp"
            "turn:turn.${vars.my.domain}:${toString cfg.turn.port-alt}?transport=udp"
          ];
          trusted_servers = [
            "matrix.org"
            "mau.chat"
          ];
          well_known_client = "https://matrix.${vars.my.domain}";
          well_known_server = "matrix.${vars.my.domain}";
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
            permissions."${vars.my.domain}" = "user";
          };
          homeserver = {
            address = "http://localhost:${toString cfg.matrix.port}";
            domain = vars.my.domain;
          };
        };
      };
      nginx.virtualHosts."matrix.${vars.my.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.matrix.port}";
      };
    };
    sops.secrets.conduit_env.owner = "conduit";
  };
}
