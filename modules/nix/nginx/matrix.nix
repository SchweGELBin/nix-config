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
    services = {
      matrix-conduit = {
        enable = true;
        settings.global = {
          allow_registration = true;
          database_backend = "rocksdb";
          enable_lightning_bolt = false;
          port = cfg.matrix.port;
          server_name = vars.my.domain;
          well_known_client = "https://matrix.${vars.my.domain}";
          well_known_server = "matrix.${vars.my.domain}";
        };
      };
      nginx.virtualHosts."matrix.${vars.my.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.matrix.port}";
      };
    };
  };
}
