{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.searx.enable;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services = {
      searx = {
        enable = true;
        environmentFile = secrets.searx_env.path;
        redisCreateLocally = true;
        settings = {
          server.port = cfg.searx.port;
          theme_args.simple_style = "black";
        };
      };
      nginx.virtualHosts.${cfg.searx.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.searx.port}";
      };
    };
    sops.secrets.searx_env.owner = "searx";
  };
}
