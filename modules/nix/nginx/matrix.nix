{
  config,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.matrix.enable;

  vars = import ../vars.nix;
in
{
  config = lib.mkIf enable {
    security.acme.certs."matrix.${vars.my.domain}" = {
      group = "matrix-synapse";
      postRun = "systemctl reload nginx.service; systemctl restart matrix-synapse.service";
    };

    services = {
      matrix-conduit = {
        enable = false;
        settings.global = {
          allow_federation = false;
          allow_registration = true;
          database_backend = "rocksdb";
          enable_lightning_bolt = false;
          port = cfg.matrix.port;
          server_name = vars.my.domain;
          well_known_client = "https://matrix.${vars.my.domain}";
          well_known_server = "matrix.${vars.my.domain}";
        };
      };
      matrix-synapse = {
        enable = true;
        settings = {
          enable_registration = true;
          enable_registration_without_verification = true;
          database.allow_unsafe_locale = true;
          listeners = [
            {
              port = cfg.matrix.port;
              resources = [
                {
                  compress = true;
                  names = [ "client" ];
                }
              ];
            }
          ];
          macaroon_secret_key = "test";
          public_baseurl = "https://matrix.${vars.my.domain}";
          server_name = vars.my.domain;
          tls_certificate_path = "/var/lib/acme/matrix.${vars.my.domain}/fullchain.pem";
          tls_private_key_path = "/var/lib/acme/matrix.${vars.my.domain}/key.pem";
          trusted_key_servers = [ ];
          web_client_location = "https://element.${vars.my.domain}";
        };
      };
      nginx.virtualHosts."matrix.${vars.my.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.matrix.port}";
      };
      postgresql = {
        enable = true;
        ensureDatabases = [ "matrix-synapse" ];
        ensureUsers = [
          {
            ensureDBOwnership = true;
            name = "matrix-synapse";
          }
        ];
      };
    };

    users.users.nginx.extraGroups = [ "matrix-synapse" ];
  };
}
