{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.ollama.enable;
in
{
  config = lib.mkIf enable {
    services = {
      nginx.virtualHosts.${cfg.ollama.web.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.ollama.web.port}";
      };
      ollama = {
        enable = true;
        loadModels = [ "moondream" ];
        port = cfg.ollama.port;
      };
      open-webui = {
        enable = cfg.ollama.web.enable;
        port = cfg.ollama.web.port;
      };
    };
  };
}
