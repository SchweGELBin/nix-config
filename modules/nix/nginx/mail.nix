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
      domains = [ cfg.domain ];
      fqdn = cfg.mail.fqdn;
      localDnsResolver = false;
      loginAccounts = {
        "master@${cfg.domain}" = {
          aliases = [ "@${cfg.domain}" ];
          hashedPasswordFile = secrets.mailhash.path;
        };
        ${cfg.forgejo.mail}.hashedPasswordFile = secrets.forgejo_mailhash.path;
        ${cfg.peertube.mail}.hashedPasswordFile = secrets.peertube_mailhash.path;
        ${cfg.vaultwarden.mail}.hashedPasswordFile = secrets.vaultwarden_mailhash.path;
      };
      stateVersion = 3;
      x509 = {
        certificateFile = "/var/lib/acme/${cfg.mail.fqdn}/cert.pem";
        privateKeyFile = "/var/lib/acme/${cfg.mail.fqdn}/key.pem";
      };
    };
    sops.secrets = {
      mailhash.owner = "dovecot2";
      forgejo_mailhash.owner = "dovecot2";
      peertube_mailhash.owner = "dovecot2";
      vaultwarden_mailhash.owner = "dovecot2";
    };
  };
}
