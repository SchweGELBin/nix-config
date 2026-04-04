{
  config,
  inputs,
  lib,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.peertube;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      peertube = {
        enable = true;
        configureNginx = true;
        database.createLocally = true;
        enableWebHttps = true;
        listenHttp = cfg.port;
        listenWeb = 443;
        localDomain = cfg.fqdn;
        redis.createLocally = true;
        secrets.secretsFile = secrets.peertube.path;
        serviceEnvironmentFile = secrets.peertube_env.path;
        settings = {
          admin.email = cfg.mail;
          client.open_in_app = {
            android.intent = {
              fallback_url = "https://f-droid.org/packages/org.framasoft.peertube/";
              host = cfg.fqdn;
            };
            ios.host = cfg.fqdn;
          };
          instance = {
            description = "Welcome to Michi's PeerTube instance!";
            name = "MiX PT";
            server_country = "Germany";
            short_description = "Michi's PeerTube instance";
          };
          signup = {
            enabled = true;
            limit = 100;
            requires_email_verification = true;
          };
          smtp = {
            from_address = cfg.mail;
            hostname = nginx.mail.fqdn;
            username = cfg.mail;
          };
          user.history.videos.enabled = false;
          video_studio.enabled = true;
        };
        smtp.passwordFile = secrets.peertube_mail.path;
      };
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
      };
    };
    sops.secrets = {
      peertube.owner = "peertube";
      peertube_mail.owner = "peertube";
      peertube_env.owner = "peertube";
    };
  };

  options = {
    sys.nginx.peertube = {
      enable = lib.mkEnableOption "Enable PeerTube";
      fqdn = lib.mkOption {
        default = "pt.${nginx.domain}";
        description = "Peertube Domain";
        type = lib.types.str;
      };
      mail = lib.mkOption {
        default = "peertube@${nginx.domain}";
        description = "Peertube Mail";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 9000;
        description = "PeerTube Port";
        type = lib.types.port;
      };
    };
  };
}
