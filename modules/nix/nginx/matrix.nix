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
    nixpkgs.config.permittedInsecurePackages = [
      "olm-3.2.16"
    ];
    services = {
      matrix-conduit = {
        enable = true;
        settings.global = {
          allow_registration = true;
          database_backend = "rocksdb";
          enable_lightning_bolt = false;
          port = cfg.matrix.port;
          server_name = vars.my.domain;
          turn_secret = "CCtSExOF9jBoi6Aj5y6boZZCImyFLQxE";
          turn_uris = [
            "turn:turn.${vars.my.domain}:${toString cfg.turn.port}?transport=tcp"
            "turn:turn.${vars.my.domain}:${toString cfg.turn.port}?transport=udp"
            "turn:turn.${vars.my.domain}:${toString cfg.turn.port-alt}?transport=tcp"
            "turn:turn.${vars.my.domain}:${toString cfg.turn.port-alt}?transport=udp"
          ];
          well_known_client = "https://matrix.${vars.my.domain}";
          well_known_server = "matrix.${vars.my.domain}";
        };
      };
      mautrix-whatsapp = {
        enable = cfg.matrix.whatsapp.enable;
        settings = {
          appservice.port = cfg.matrix.whatsapp.port;
          bridge = {
            encryption.allow = true;
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
  };
}
