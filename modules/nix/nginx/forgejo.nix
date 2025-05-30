{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.forgejo.enable;
in
{
  config = lib.mkIf enable {
    services = {
      forgejo = {
        enable = true;
        database.type = "postgres";
        lfs.enable = true;
        settings = {
          mailer = {
            ENABLED = true;
            FROM = cfg.forgejo.mail;
            PROTOCOL = "sendmail";
            SENDMAIL_PATH = "${pkgs.system-sendmail}/bin/sendmail";
          };
          server = {
            DOMAIN = cfg.forgejo.fqdn;
            HTTP_PORT = cfg.forgejo.port;
            PROTOCOL = "https";
            ROOT_URL = "https://${cfg.forgejo.fqdn}";
          };
          session.COOKIE_SECURE = true;
        };
      };
      nginx.virtualHosts.${cfg.forgejo.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.forgejo.port}";
      };
    };
  };
}
