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
        localDomain = cfg.peertube.fqdn;
        redis.createLocally = true;
        secrets.secretsFile = secrets.peertube.path;
        serviceEnvironmentFile = secrets.peertube_env.path;
        settings = {
          admin.email = cfg.peertube.mail;
          client.open_in_app = {
            android.intent = {
              fallback_url = "https://f-droid.org/packages/org.framasoft.peertube/";
              host = cfg.peertube.fqdn;
            };
            ios.host = cfg.peertube.fqdn;
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
            from_address = cfg.peertube.mail;
            hostname = cfg.mail.fqdn;
            username = cfg.peertube.mail;
          };
          user.history.videos.enabled = false;
          video_studio.enabled = true;
        };
        smtp.passwordFile = secrets.peertube_mail.path;
      };
      nginx.virtualHosts.${cfg.peertube.fqdn} = {
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
