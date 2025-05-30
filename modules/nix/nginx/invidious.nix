{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.invidious.enable;
in
{
  config = lib.mkIf enable {
    services.invidious = {
      enable = true;
      domain = cfg.invidious.fqdn;
      nginx.enable = true;
      port = cfg.invidious.port;
    };
  };
}
