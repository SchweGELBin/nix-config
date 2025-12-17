{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.websurfx.enable;
in
{
  config = lib.mkIf enable {
    services = {
      nginx.virtualHosts.${cfg.websurfx.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.websurfx.port}";
      };
      /*
        https://github.com/NixOS/nixpkgs/pull/471684
        websurfx = {
          enable = true;
          redis.port = cfg.websurfx.redis-port;
          settings.port = cfg.websurfx.port;
        };
      */
    };
  };
}
