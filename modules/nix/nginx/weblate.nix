{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.weblate.enable;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services = {
      weblate = {
        enable = true;
        djangoSecretKeyFile = secrets.weblate_django.path;
        localDomain = cfg.weblate.fqdn;
        smtp = {
          host = cfg.domain;
          user = cfg.weblate.mail;
          passwordFile = secrets.weblate_mail.path;
        };
      };
      nginx.virtualHosts.${cfg.weblate.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.weblate.port}";
      };
    };
    sops.secrets = {
      weblate_django.owner = "weblate";
      weblate_mail.owner = "weblate";
    };
  };
}
