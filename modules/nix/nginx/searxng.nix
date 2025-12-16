{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.searxng.enable;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services = {
      nginx.virtualHosts.${cfg.searxng.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.searxng.port}";
      };
      searx = {
        enable = true;
        environmentFile = secrets.searx_env.path;
        redisCreateLocally = true;
        settings = {
          server.port = cfg.searxng.port;
          theme_args.simple_style = "black";
        };
      };
    };
    sops.secrets.searx_env.owner = "searx";
  };
}
