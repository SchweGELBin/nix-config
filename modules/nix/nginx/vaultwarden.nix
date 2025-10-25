{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.vaultwarden.enable;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services = {
      vaultwarden = {
        enable = true;
        backupDir = "/var/backup/vaultwarden";
        config = {
          DOMAIN = "https://${cfg.vaultwarden.fqdn}";
          ROCKET_PORT = cfg.vaultwarden.port;
          SIGNUPS_VERIFY = true;
          SMTP_FROM = cfg.vaultwarden.mail;
          SMTP_FROM_NAME = "MiX Vaultwarden";
          SMTP_HOST = cfg.mail.fqdn;
          SMTP_USERNAME = cfg.vaultwarden.mail;
        };
        environmentFile = secrets.vaultwarden.path;
      };
      nginx.virtualHosts.${cfg.vaultwarden.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.vaultwarden.port}";
      };
    };
    sops.secrets.vaultwarden.owner = "vaultwarden";
  };
}
