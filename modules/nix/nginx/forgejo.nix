{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.forgejo.enable;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    security.acme.certs.${cfg.forgejo.fqdn} = {
      group = "forgejo";
      postRun = "systemctl reload nginx.service; systemctl restart forgejo.service";
    };
    services = {
      forgejo = {
        enable = true;
        package = pkgs.forgejo;
        database.type = "postgres";
        lfs.enable = true;
        secrets.mailer.PASSWD = secrets.forgejo_mail.path;
        settings = {
          mailer = {
            ENABLED = true;
            FROM = cfg.forgejo.mail;
            PROTOCOL = "smtps";
            SMTP_ADDR = cfg.mail.fqdn;
            USER = cfg.forgejo.mail;
          };
          server = {
            CERT_FILE = "/var/lib/acme/${cfg.forgejo.fqdn}/cert.pem";
            DOMAIN = cfg.forgejo.fqdn;
            HTTP_PORT = cfg.forgejo.port;
            KEY_FILE = "/var/lib/acme/${cfg.forgejo.fqdn}/key.pem";
            ROOT_URL = "https://${cfg.forgejo.fqdn}";
          };
          service.REGISTER_EMAIL_CONFIRM = true;
          session.COOKIE_SECURE = true;
        };
      };
      nginx.virtualHosts.${cfg.forgejo.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.forgejo.port}";
      };
    };
    sops.secrets = {
      forgejo.owner = "forgejo";
      forgejo_mail.owner = "forgejo";
    };
    systemd.services.forgejo.preStart = ''
      ${lib.getExe config.services.forgejo.package} admin user create \
      --admin --email ${cfg.forgejo.mail} --username ${cfg.forgejo.username} \
      --password $(cat ${secrets.forgejo.path}) || true
    '';
    users.users.nginx.extraGroups = [ "forgejo" ];
  };
}
