{ config, lib, ... }:
let
  nginx = config.sys.nginx;
  cfg = nginx.filebrowser;
  vars = import ../../vars.nix;
in
{
  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
      filebrowser = {
        enable = true;
        settings = {
          password = "$2a$10$Pmb6Lp5JvxhaFcvkOn4NhuBNtZ8V4tC3CjrVuM0kaOdv47wV0Izse";
          port = cfg.port;
          username = vars.user.name;
        };
      };
    };
  };

  options = {
    sys.nginx.filebrowser = {
      enable = lib.mkEnableOption "Enable FileBrowser";
      fqdn = lib.mkOption {
        default = "files.${nginx.domain}";
        description = "FileBrowser Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 8181;
        description = "FileBrowser Port";
        type = lib.types.port;
      };
    };
  };
}
