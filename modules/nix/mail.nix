{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.mail;

  secrets = config.sops.secrets;
  vars = import ./vars.nix;
in
{
  imports = [
    inputs.mailserver.nixosModules.default
    inputs.sops-nix.nixosModules.default
  ];
  config = lib.mkIf cfg.enable {
    mailserver = {
      enable = true;
      enableImapSsl = false;
      enableManageSieve = false;
      enablePop3Ssl = false;
      enableSubmissionSsl = false;
      certificateScheme = "acme-nginx";
      domains = [ vars.my.domain ];
      fqdn = "mail.${vars.my.domain}";
      localDnsResolver = false;
      loginAccounts = {
        "master@${vars.my.domain}" = {
          aliases = [ "@${vars.my.domain}" ];
          hashedPasswordFile = secrets.mail.path;
        };
      };
    };
    networking.firewall.allowedTCPPorts = [
      110
      143
      587
    ];

    sops.secrets.mail = { };
  };

  options = {
    sys.mail.enable = lib.mkEnableOption "Enable Mail Server";
  };
}
