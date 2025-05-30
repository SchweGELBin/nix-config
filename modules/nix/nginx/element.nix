{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.element.enable;
in
{
  config = lib.mkIf enable {
    services = {
      nginx.virtualHosts.${cfg.element.fqdn} = {
        enableACME = true;
        forceSSL = true;
        root = pkgs.element-web.override {
          conf = {
            default_server_config."m.homeserver" = {
              base_url = "https://${cfg.matrix.fqdn}";
              server_name = cfg.domain;
            };
            default_theme = "dark";
            disable_custom_urls = true;
          };
        };
      };
    };
  };
}
