{
  config,
  lib,
  pkgs,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.whoogle;
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
      whoogle-search = {
        enable = true;
        extraEnv = {
          WHOOGLE_AUTOCOMPLETE = "0";
          WHOOGLE_CONFIG_COUNTRY = "US";
          WHOOGLE_CONFIG_LANGUAGE = "lang_en";
          WHOOGLE_CONFIG_SEARCH_LANGUAGE = "lang_en";
          WHOOGLE_CONFIG_STYLE = lib.mkIf config.sys.catppuccin.enable (
            lib.readFile ("${pkgs.catppuccin}/whoogle/${vars.cat.flavor}.css")
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
