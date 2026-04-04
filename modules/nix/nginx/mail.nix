{
  config,
  inputs,
  lib,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.mail;
  secrets = config.sops.secrets;
in
{
  imports = [
    inputs.mailserver.nixosModules.default
    inputs.sops-nix.nixosModules.default
  ];

  config = lib.mkIf (nginx.enable && cfg.enable) {
    mailserver = {
      enable = true;
      accounts = {
        "master@${nginx.domain}" = {
          aliases = [ "@${nginx.domain}" ];
          hashedPasswordFile = secrets.mailhash.path;
        };
        ${nginx.forgejo.mail}.hashedPasswordFile = secrets.forgejo_mailhash.path;
        ${nginx.peertube.mail}.hashedPasswordFile = secrets.peertube_mailhash.path;
        ${nginx.vaultwarden.mail}.hashedPasswordFile = secrets.vaultwarden_mailhash.path;
        ${nginx.weblate.mail}.hashedPasswordFile = secrets.weblate_mailhash.path;
      };
      domains = [ nginx.domain ];
      fqdn = cfg.fqdn;
      localDnsResolver = false;
      stateVersion = 3;
      x509.useACMEHost = nginx.domain;
    };
    sops.secrets = {
      mailhash.owner = "dovecot2";
      forgejo_mailhash.owner = "dovecot2";
      peertube_mailhash.owner = "dovecot2";
      vaultwarden_mailhash.owner = "dovecot2";
      weblate_mailhash.owner = "dovecot2";
    };
  };

  options = {
    sys.nginx.mail = {
      enable = lib.mkEnableOption "Enable Mail Server";
      fqdn = lib.mkOption {
        default = "mail.${nginx.domain}";
        description = "Mail Server Domain";
        type = lib.types.str;
      };
    };
  };
}
