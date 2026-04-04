{
  config,
  inputs,
  lib,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.weblate;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      weblate = {
        enable = true;
        djangoSecretKeyFile = secrets.weblate_django.path;
        localDomain = cfg.fqdn;
        smtp = {
          host = nginx.domain;
          user = cfg.mail;
          passwordFile = secrets.weblate_mail.path;
        };
      };
    };
    sops.secrets = {
      weblate_django.owner = "weblate";
      weblate_mail.owner = "weblate";
    };
  };

  options = {
    sys.nginx.weblate = {
      enable = lib.mkEnableOption "Enable Weblate";
      fqdn = lib.mkOption {
        default = "weblate.${nginx.domain}";
        description = "Weblate Domain";
        type = lib.types.str;
      };
      mail = lib.mkOption {
        default = "weblate@${nginx.domain}";
        description = "Weblate Mail";
        type = lib.types.str;
      };
    };
  };
}
