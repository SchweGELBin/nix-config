{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.mail.enable;
  secrets = config.sops.secrets;
in
{
  imports = [
    inputs.mailserver.nixosModules.default
    inputs.sops-nix.nixosModules.default
  ];

  config = lib.mkIf enable {
    mailserver = {
      enable = true;
      accounts = {
        "master@${cfg.domain}" = {
          aliases = [ "@${cfg.domain}" ];
          hashedPasswordFile = secrets.mailhash.path;
        };
        ${cfg.forgejo.mail}.hashedPasswordFile = secrets.forgejo_mailhash.path;
        ${cfg.peertube.mail}.hashedPasswordFile = secrets.peertube_mailhash.path;
        ${cfg.vaultwarden.mail}.hashedPasswordFile = secrets.vaultwarden_mailhash.path;
        ${cfg.weblate.mail}.hashedPasswordFile = secrets.weblate_mailhash.path;
      };
      domains = [ cfg.domain ];
      fqdn = cfg.mail.fqdn;
      localDnsResolver = false;
      stateVersion = 3;
      x509.useACMEHost = cfg.domain;
    };
    sops.secrets = {
      mailhash.owner = "dovecot2";
      forgejo_mailhash.owner = "dovecot2";
      peertube_mailhash.owner = "dovecot2";
      vaultwarden_mailhash.owner = "dovecot2";
      weblate_mailhash.owner = "dovecot2";
    };
  };
}
