{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.thelounge.enable;
in
{
  config = lib.mkIf enable {
    services = {
      nginx.virtualHosts.${cfg.thelounge.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.ergo.port}";
      };
      thelounge = {
        enable = true;
        extraConfig = {
          defaults = {
            host = "localhost";
            join = "#general";
            name = "MiX";
            nick = "Gast%%%%";
            leaveMessage = "Tschau";
          };
          reverseProxy = true;
        };
        port = cfg.ergo.port;
        public = true;
      };
    };
  };
}
