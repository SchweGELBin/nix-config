{
  config,
  lib,
  pkgs,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.whoogle;
in
{
  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
      whoogle-search = {
        enable = true;
        extraEnv = {
          WHOOGLE_AUTOCOMPLETE = "0";
          WHOOGLE_CONFIG_COUNTRY = "US";
          WHOOGLE_CONFIG_LANGUAGE = "lang_en";
          WHOOGLE_CONFIG_SEARCH_LANGUAGE = "lang_en";
          WHOOGLE_CONFIG_STYLE = lib.mkIf config.sys.catppuccin.enable (
            lib.readFile (
              pkgs.fetchurl {
                url = "https://raw.githubusercontent.com/catppuccin/whoogle/9d961dc6e2ac405fee18ee1da9a14db1f139db39/env/mocha.env";
                hash = "sha256-P9cVZglIVdo4vxDJ3+Df9zcEO7pDqrFClzNUuAIcMkQ=";
              }
            )
          );
          WHOOGLE_CONFIG_THEME = "dark";
          WHOOGLE_CONFIG_URL = "https://${cfg.fqdn}";
        };
        port = cfg.port;
      };
    };
  };

  options = {
    sys.nginx.whoogle = {
      enable = lib.mkEnableOption "Enable Whoogle";
      fqdn = lib.mkOption {
        default = "whoogle.${nginx.domain}";
        description = "Whoogle Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 5000;
        description = "Whoogle Port";
        type = lib.types.port;
      };
    };
  };
}
