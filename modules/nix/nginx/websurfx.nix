{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.websurfx.enable;
in
{
  config = lib.mkIf enable {
    services.nginx.virtualHosts.${cfg.websurfx.fqdn} = {
      enableACME = true;
      forceSSL = true;
      root = pkgs.websurfx;
    };
  };
}
