{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.microbin.enable;

  vars = import ../vars.nix;
in
{
  config = lib.mkIf enable {
    services = {
      microbin = {
        enable = true;
        settings.MICROBIN_PORT = cfg.microbin.port;
      };
      nginx.virtualHosts."microbin.${vars.my.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.microbin.port}";
      };
    };
  };
}
