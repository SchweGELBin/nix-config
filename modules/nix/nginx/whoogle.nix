{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.whoogle.enable;
in
{
  config = lib.mkIf enable {
    services = {
      nginx.virtualHosts.${cfg.whoogle.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.whoogle.port}";
      };
      whoogle-search = {
        enable = true;
        extraEnv = {
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
        };
        port = cfg.whoogle.port;
      };
    };
  };
}
