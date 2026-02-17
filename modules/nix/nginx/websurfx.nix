{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.websurfx.enable;
in
{
  config = lib.mkIf enable {
    services = {
      nginx.virtualHosts.${cfg.websurfx.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.websurfx.port}";
      };
      /*
        https://github.com/NixOS/nixpkgs/pull/471684
        websurfx = {
          enable = true;
          settings = {
            port = cfg.websurfx.port;
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
      */
    };
  };
}
