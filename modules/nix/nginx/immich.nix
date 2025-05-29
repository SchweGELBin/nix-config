{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.immich.enable;

  vars = import ../vars.nix;
in
{
  config = lib.mkIf enable {
    services = {
      immich = {
        enable = true;
        port = cfg.immich.port;
        settings.server.externalDomain = "https://immich.${vars.my.domain}";
      };
      nginx.virtualHosts."immich.${vars.my.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.immich.port}";
      };
    };
  };
}
