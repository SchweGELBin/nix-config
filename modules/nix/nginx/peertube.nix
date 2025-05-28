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
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services.peertube = {
      enable = true;
      configureNginx = true;
      database.createLocally = true;
      listenHttp = cfg.peertube.port;
      localDomain = "peertube.${vars.my.domain}";
      redis.createLocally = true;
      secrets.secretsFile = secrets.peertube.path;
      settings = {
        listen.hostname = "0.0.0.0";
        log.level = "info";
      };
    };
    sops.secrets.peertube.owner = "peertube";
  };
}
