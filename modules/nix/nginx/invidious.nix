{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.invidious.enable;

  vars = import ../vars.nix;
in
{
  config = lib.mkIf enable {
    services.invidious = {
      enable = true;
      domain = "iv.${vars.my.domain}";
      nginx.enable = true;
      port = cfg.invidious.port;
    };
  };
}
