{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.thelounge.enable;
  secrets = config.sops.secrets;
  vars = import ../../vars.nix;
in
{
  config = lib.mkIf enable {
    services = {
      ergochat = {
        enable = true;
        settings = {
          network.name = "MiX";
          server = {
            name = vars.my.domain;
            listeners = {
              "127.0.0.1:${toString cfg.thelounge.port}" = { };
              "[::1]:${toString cfg.thelounge.port}" = { };
            };
          };
          opers.password = secrets.ergo.path;
        };
      };
      nginx.virtualHosts.${cfg.thelounge.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.thelounge.port}";
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
            username = "gast";
          };
          reverseProxy = true;
        };
        port = cfg.thelounge.port;
        public = true;
      };
    };
    sops.secrets.ergo.owner = "root";
  };
}
