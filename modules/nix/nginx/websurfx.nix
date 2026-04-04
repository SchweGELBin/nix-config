{ config, lib, ... }:
let
  nginx = config.sys.nginx;
  cfg = nginx.websurfx;
in
{
  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
      websurfx = {
        enable = true;
        settings = {
          port = cfg.port;
          upstream_search_engines = {
            DuckDuckGo = true;
            Searx = false;
            Brave = false;
            Startpage = false;
            LibreX = false;
            Mojeek = true;
            Bing = false;
            Wikipedia = false;
            Yahoo = false;
          };
        };
      };
    };
  };

  options = {
    sys.nginx.websurfx = {
      enable = lib.mkEnableOption "Enable Websurfx";
      fqdn = lib.mkOption {
        default = "surfx.${nginx.domain}";
        description = "Websurfx Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 4567;
        description = "Websurfx Port";
        type = lib.types.port;
      };
    };
  };
}
