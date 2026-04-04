{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.forgejo;
  vars = import ../../vars.nix;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf (nginx.enable && cfg.enable) {
    security.acme.certs.${cfg.fqdn} = {
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
            FROM = cfg.mail;
            PROTOCOL = "smtps";
            SMTP_ADDR = nginx.mail.fqdn;
            USER = cfg.mail;
          };
          server = {
            CERT_FILE = "/var/lib/acme/${cfg.fqdn}/cert.pem";
            DOMAIN = cfg.fqdn;
            HTTP_PORT = cfg.port;
            KEY_FILE = "/var/lib/acme/${cfg.fqdn}/key.pem";
            ROOT_URL = "https://${cfg.fqdn}";
          };
          service.REGISTER_EMAIL_CONFIRM = true;
          session.COOKIE_SECURE = true;
        };
      };
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
    };
    sops.secrets = {
      forgejo.owner = "forgejo";
      forgejo_mail.owner = "forgejo";
    };
    systemd.services.forgejo.preStart = ''
      ${lib.getExe config.services.forgejo.package} admin user create \
      --admin --email ${cfg.mail} --username ${cfg.username} \
      --password $(cat ${secrets.forgejo.path}) || true
    '';
    users.users.nginx.extraGroups = [ "forgejo" ];
  };

  options = {
    sys.nginx.forgejo = {
      enable = lib.mkEnableOption "Enable Forgejo";
      fqdn = lib.mkOption {
        default = "git.${nginx.domain}";
        description = "Forgejo Domain";
        type = lib.types.str;
      };
      mail = lib.mkOption {
        default = "forgejo@${nginx.domain}";
        description = "Forgejo Mail";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 3000;
        description = "Forgejo Port";
        type = lib.types.port;
      };
      username = lib.mkOption {
        default = vars.user.name;
        description = "Forgejo Admin Username";
        type = lib.types.str;
      };
    };
  };
}
