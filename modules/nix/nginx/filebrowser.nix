{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.filebrowser.enable;

  vars = import ../../vars.nix;
in
{
  config = lib.mkIf enable {
    services = {
      nginx.virtualHosts.${cfg.filebrowser.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.filebrowser.port}";
      };
      filebrowser = {
        enable = true;
        settings = {
          password = "$2a$10$Pmb6Lp5JvxhaFcvkOn4NhuBNtZ8V4tC3CjrVuM0kaOdv47wV0Izse";
          port = cfg.filebrowser.port;
          username = vars.user.name;
        };
      };
    };
  };
}
