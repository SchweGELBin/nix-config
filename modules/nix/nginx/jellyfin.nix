{ config, lib, ... }:
let
  nginx = config.sys.nginx;
  cfg = nginx.jellyfin;
in
{
  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      jellyfin.enable = true;
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
    };
  };

  options = {
    sys.nginx.jellyfin = {
      enable = lib.mkEnableOption "Enable Jellyfin";
      fqdn = lib.mkOption {
        default = "jelly.${nginx.domain}";
        description = "Jellyfin Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 8096;
        description = "Jellyfin Port";
        type = lib.types.port;
      };
    };
  };
}
