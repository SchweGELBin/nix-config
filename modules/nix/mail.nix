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
      certificateScheme = "acme-nginx";
      domains = [ vars.my.domain ];
      fqdn = "mail.${vars.my.domain}";
      loginAccounts = {
        "master@${vars.my.domain}" = {
          aliases = [ "@${vars.my.domain}" ];
          hashedPasswordFile = secrets.mail.path;
        };
      };
    };
    sops.secrets.mail = { };
  };

  options = {
    sys.mail.enable = lib.mkEnableOption "Enable Mail Server";
  };
}
