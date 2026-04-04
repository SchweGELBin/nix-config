{
  config,
  lib,
  pkgs,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.element;
in
{
  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        root = pkgs.element-web.override {
          conf = {
            default_country_code = "DE";
            default_server_config."m.homeserver" = {
              base_url = "https://${nginx.domain}";
              server_name = nginx.domain;
            };
            default_theme = "dark";
            disable_custom_urls = true;
            disable_guests = true;
            mobile_guide_toast = false;
          };
        };
      };
    };
  };

  options = {
    sys.nginx.element = {
      enable = lib.mkEnableOption "Enable Element";
      fqdn = lib.mkOption {
        default = "element.${nginx.domain}";
        description = "Element Domain";
        type = lib.types.str;
      };
    };
  };
}
