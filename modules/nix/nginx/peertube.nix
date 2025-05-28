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
        settings = {
          listen.hostname = "0.0.0.0";
          log.level = "info";
        };
      };
      nginx.virtualHosts."${domain}" = {
        enableACME = true;
        forceSSL = true;
      };
    };
    sops.secrets.peertube.owner = "peertube";
  };
}
