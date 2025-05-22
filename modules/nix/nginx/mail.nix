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
  vars = import ../vars.nix;
in
{
  imports = [
    inputs.mailserver.nixosModules.default
    inputs.sops-nix.nixosModules.default
  ];
  config = lib.mkIf enable {
    mailserver = {
      enable = true;
      certificateScheme = "acme-nginx";
      domains = [ vars.my.domain ];
      fqdn = "mail.${vars.my.domain}";
      localDnsResolver = false;
      loginAccounts = {
        "master@${vars.my.domain}" = {
          aliases = [ "@${vars.my.domain}" ];
          hashedPasswordFile = secrets.mailhash.path;
        };
      };
    };
    sops.secrets.mailhash.owner = "dovecot2";
  };
}
