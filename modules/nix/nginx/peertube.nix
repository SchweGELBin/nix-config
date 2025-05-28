{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.peertube.enable;

  secrets = config.sops.secrets;
  vars = import ../vars.nix;

  domain = "peertube.${vars.my.domain}";
  mail = "peertube@${vars.my.domain}";
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services = {
      peertube = {
        enable = true;
        configureNginx = true;
        database.createLocally = true;
        enableWebHttps = true;
        listenHttp = cfg.peertube.port;
        listenWeb = 443;
        localDomain = domain;
        redis.createLocally = true;
        secrets.secretsFile = secrets.peertube.path;
        serviceEnvironmentFile = secrets.peertube_env.path;
        settings = {
          admin.email = mail;
          client.open_in_app = {
            android.intent = {
              fallback_url = "https://f-droid.org/packages/org.framasoft.peertube/";
              host = domain;
            };
            ios.host = domain;
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
            from_address = mail;
            hostname = "mail.${vars.my.domain}";
            username = mail;
          };
          user.history.videos.enabled = false;
          video_studio.enabled = true;
        };
        smtp.passwordFile = secrets.peertube_mail.path;
      };
      nginx.virtualHosts."${domain}" = {
        enableACME = true;
        forceSSL = true;
      };
    };
    sops.secrets = {
      peertube.owner = "peertube";
      peertube_env.owner = "peertube";
      peertube_mail.owner = "peertube";
    };
  };
}
