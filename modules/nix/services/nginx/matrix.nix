{
  config,
  lib,
  ...
}:
let
  vars = import ../../vars.nix;
in
{
  config = lib.mkIf config.sys.services.nginx.matrix.enable {
    services = {
      matrix-conduit = {
        enable = true;
        settings.global = {
          allow_registration = true;
          database_backend = "rocksdb";
          enable_lightning_bolt = false;
          port = config.sys.nginx.matrix.port;
          server_name = vars.my.domain;
          well_known_client = "https://matrix.${vars.my.domain}";
          well_known_server = "matrix.${vars.my.domain}";
        };
      };
      nginx.virtualHosts."matrix.${vars.my.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${config.sys.services.nginx.matrix.port}";
      };
    };
  };

  options = {
    sys.services.nginx.matrix = {
      enable = lib.mkEnableOption "Enable Matrix";
      port = lib.mkOption {
        description = "Matrix Port";
        type = lib.types.int;
      };
    };
  };
}
