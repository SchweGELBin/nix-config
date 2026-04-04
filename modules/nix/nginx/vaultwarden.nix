{
  config,
  inputs,
  lib,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.vaultwarden;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      vaultwarden = {
        enable = true;
        backupDir = "/var/backup/vaultwarden";
        config = {
          DOMAIN = "https://${cfg.fqdn}";
          ROCKET_PORT = cfg.port;
          SIGNUPS_VERIFY = true;
          SMTP_FROM = cfg.mail;
          SMTP_FROM_NAME = "MiX Vaultwarden";
          SMTP_HOST = nginx.mail.fqdn;
          SMTP_USERNAME = cfg.mail;
        };
        environmentFile = secrets.vaultwarden.path;
      };
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
    };
    sops.secrets.vaultwarden.owner = "vaultwarden";
  };

  options = {
    sys.nginx.vaultwarden = {
      enable = lib.mkEnableOption "Enable Vaultwarden";
      fqdn = lib.mkOption {
        default = "vault.${nginx.domain}";
        description = "Vaultwarden Domain";
        type = lib.types.str;
      };
      mail = lib.mkOption {
        default = "vault@${nginx.domain}";
        description = "Vaultwarden Mail";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 8222;
        description = "Vaultwarden Port";
        type = lib.types.port;
      };
    };
  };
}
